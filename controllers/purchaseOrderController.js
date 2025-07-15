const { PurchaseOrder, PurchaseOrderItem, Supplier, PurchaseRequest, Barang, PurchaseRequestItem, sequelize } = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

exports.getAll = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', status = '', startDate, endDate } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [Op.or]: [
          { kode: { [Op.like]: `%${search}%` } },
          { status: { [Op.like]: `%${search}%` } },
          { catatan: { [Op.like]: `%${search}%` } }
        ]
      };
    }

    // Add status filter
    if (status) {
      whereClause.status = status;
    }

    // Add date filtering
    if (startDate || endDate) {
      const dateFilter = {};
      if (startDate) {
        dateFilter[Op.gte] = startDate;
      }
      if (endDate) {
        dateFilter[Op.lte] = endDate;
      }
      whereClause.tanggal = dateFilter;
    }

    const { count, rows } = await PurchaseOrder.findAndCountAll({
      where: whereClause,
      include: [
        { model: Supplier },
        { model: PurchaseRequest },
        {
          model: PurchaseOrderItem,
          as: 'items',
          include: [Barang],
        },
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']],
      distinct: true // Important for accurate count with joins
    });

    res.json({
      data: rows,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(count / limit),
        totalItems: count,
        itemsPerPage: parseInt(limit),
        hasNextPage: page * limit < count,
        hasPrevPage: page > 1
      }
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_ORDER',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data', error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await PurchaseOrder.findByPk(req.params.id, {
      include: [
        { model: Supplier },
        { model: PurchaseRequest },
        {
          model: PurchaseOrderItem,
          as: 'items',
          include: [Barang],
        },
      ],
    });
    if (!data) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json(data);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_ORDER',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil detail', error: err.message });
  }
};

exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, supplierId, purchaseRequestId, catatan, items } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items tidak boleh kosong' });
    }

    const kode = await generateCode('purchase-order', t);
    
    const po = await PurchaseOrder.create({
      kode,
      tanggal,
      supplierId,
      purchaseRequestId,
      catatan,
      status: 'draft',
    }, { transaction: t });

    for (const item of items) {
      const subtotal = parseFloat(item.qty) * parseFloat(item.harga);
      await PurchaseOrderItem.create({
        purchaseOrderId: po.id,
        barangId: item.barangId,
        qty: item.qty,
        harga: item.harga,
        subtotal,
      }, { transaction: t });
    }

    await t.commit();
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'purchase_order',
      po.id,
      { kode: po.kode, tanggal, supplierId, purchaseRequestId, catatan, itemsCount: items.length },
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json({ message: 'Purchase Order berhasil dibuat', data: po });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_ORDER',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal membuat PO', error: err.message });
  }
};

exports.update = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, supplierId, purchaseRequestId, catatan, status, items } = req.body;
    const id = req.params.id;

    const po = await PurchaseOrder.findByPk(id);
    if (!po) return res.status(404).json({ message: 'PO tidak ditemukan' });

    const oldData = {
      tanggal: po.tanggal,
      supplierId: po.supplierId,
      purchaseRequestId: po.purchaseRequestId,
      catatan: po.catatan,
      status: po.status
    };

    await po.update({ tanggal, supplierId, purchaseRequestId, catatan, status }, { transaction: t });

    // Only update items if they are provided
    if (items && Array.isArray(items)) {
      await PurchaseOrderItem.destroy({ where: { purchaseOrderId: id }, transaction: t });

      for (const item of items) {
        const subtotal = parseFloat(item.qty) * parseFloat(item.harga);
        await PurchaseOrderItem.create({
          purchaseOrderId: id,
          barangId: item.barangId,
          qty: item.qty,
          harga: item.harga,
          subtotal,
        }, { transaction: t });
      }
    }

    await t.commit();
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'purchase_order',
      po.id,
      oldData,
      { tanggal, supplierId, purchaseRequestId, catatan, status, itemsCount: items?.length || 0 },
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'PO berhasil diupdate' });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_ORDER',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal update PO', error: err.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const id = req.params.id;
    const po = await PurchaseOrder.findByPk(id);
    if (!po) return res.status(404).json({ message: 'Data tidak ditemukan' });

    const poData = {
      id: po.id,
      kode: po.kode,
      tanggal: po.tanggal,
      supplierId: po.supplierId,
      purchaseRequestId: po.purchaseRequestId,
      catatan: po.catatan,
      status: po.status
    };

    await PurchaseOrder.destroy({ where: { id } });
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'purchase_order',
      po.id,
      poData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_ORDER',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal hapus', error: err.message });
  }
};

exports.createFromPurchaseRequest = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const purchaseRequestId = req.params.purchaseRequestId;
    const { supplierId, tanggal, catatan } = req.body;

    // 1. Validate inputs
    if (!purchaseRequestId) return res.status(400).json({ message: 'Purchase Request ID wajib diisi' });
    if (!supplierId) return res.status(400).json({ message: 'Supplier wajib dipilih' });
    
    // 2. Validate PR exists and is approved
    const pr = await PurchaseRequest.findByPk(purchaseRequestId, {
      include: [{ model: PurchaseRequestItem, as: 'items' }],
    });
    if (!pr) return res.status(404).json({ message: 'Purchase Request tidak ditemukan' });
    if (pr.status !== 'disetujui') return res.status(400).json({ message: 'Purchase Request belum disetujui' });
    if (!pr.items || pr.items.length === 0) return res.status(400).json({ message: 'Tidak ada item pada Purchase Request' });
    
    // 3. Validate supplier exists
    const supplier = await Supplier.findByPk(supplierId);
    if (!supplier) return res.status(404).json({ message: 'Supplier tidak ditemukan' });

    // 4. Generate kode PO and create PO
    const kode = await generateCode('purchase-order', t);
    
    // 5. Create PO
    po = await PurchaseOrder.create({
      kode,
      tanggal: tanggal || new Date().toISOString().split('T')[0],
      supplierId: parseInt(supplierId),
      purchaseRequestId: parseInt(pr.id),
      catatan: catatan || null,
      status: 'draft',
    }, { transaction: t });

    // 6. Copy items from PR to PO (harga default 0.00, to be filled later)
    for (const item of pr.items) {
      await PurchaseOrderItem.create({
        purchaseOrderId: po.id,
        barangId: item.barangId,
        qty: parseInt(item.qty),
        harga: 0.00,
        subtotal: 0.00,
      }, { transaction: t });
    }

    await t.commit();
    const result = await PurchaseOrder.findByPk(po.id, {
      include: [
        { model: Supplier },
        { model: PurchaseRequest },
        { model: PurchaseOrderItem, as: 'items', include: [Barang] },
      ],
    });
    res.status(201).json({ message: 'PO berhasil dibuat dari PR', data: result });
  } catch (err) {
    await t.rollback();
    console.error('Error creating PO from PR:', err);
    res.status(500).json({ 
      message: 'Gagal membuat PO dari PR', 
      error: err.message,
      details: err.errors ? err.errors.map(e => e.message) : undefined
    });
  }
};

// GET purchase orders available for good receipt (sent/received but no GR yet)
exports.getAvailableForGoodReceipt = async (req, res) => {
  try {
    const data = await PurchaseOrder.findAll({
      include: [
        { model: Supplier },
        {
          model: PurchaseOrderItem,
          as: 'items',
          include: [Barang],
        },
      ],
      where: {
        status: {
          [Op.in]: ['dikirim', 'partial_received']
        }
      },
      order: [['createdAt', 'DESC']],
    });
    res.json(data);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data PO tersedia', error: err.message });
  }
};
