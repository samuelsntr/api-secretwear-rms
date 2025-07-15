const {
  PurchaseReturn,
  PurchaseReturnItem,
  GoodReceipt,
  GoodReceiptItem,
  Barang,
  StockGudangPusat,
  PurchaseOrder,
  Supplier,
  sequelize,
} = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

// GET all purchase returns with pagination, search, and date filtering
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
          { catatan: { [Op.like]: `%${search}%` } },
          { return_reason: { [Op.like]: `%${search}%` } }
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

    const { count, rows } = await PurchaseReturn.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: GoodReceipt,
          include: [
            {
              model: PurchaseOrder,
              include: [Supplier],
            },
          ],
        },
        {
          model: PurchaseReturnItem,
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
      'PURCHASE_RETURN',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data', error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await PurchaseReturn.findByPk(req.params.id, {
      include: [
        {
          model: GoodReceipt,
          include: [
            {
              model: PurchaseOrder,
              include: [Supplier],
            },
          ],
        },
        {
          model: PurchaseReturnItem,
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
      'PURCHASE_RETURN',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil detail', error: err.message });
  }
};

exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, goodReceiptId, catatan, return_reason, items } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items tidak boleh kosong' });
    }

    const gr = await GoodReceipt.findByPk(goodReceiptId, {
      include: [{ model: GoodReceiptItem, as: 'items' }],
    });
    if (!gr) return res.status(404).json({ message: 'Good Receipt tidak ditemukan' });

    const kode = await generateCode('purchase-return', t);
    let total_amount = 0;

    for (const item of items) {
      const grItem = gr.items.find(i => i.barangId === item.barangId);
      if (!grItem)
        throw new Error(`Barang dengan ID ${item.barangId} tidak ada di GR ini`);

      const totalQtyReturned = await PurchaseReturnItem.sum('qty', {
        where: {
          purchaseReturnId: {
            [Op.in]: sequelize.literal(`(
              SELECT id FROM purchase_returns WHERE goodReceiptId = ${goodReceiptId}
            )`),
          },
          barangId: item.barangId,
        },
        transaction: t,
      }) || 0;

      const maxReturnQty = parseFloat(grItem.qty_diterima) - totalQtyReturned;
      if (parseFloat(item.qty) > maxReturnQty) {
        throw new Error(`Quantity return untuk item ${item.barangId} melebihi quantity yang bisa dikembalikan (max: ${maxReturnQty})`);
      }

      const subtotal = parseFloat(item.qty) * parseFloat(item.unit_price || 0);
      total_amount += subtotal;
    }

    const pr = await PurchaseReturn.create(
      { kode, tanggal, goodReceiptId, catatan, return_reason, total_amount, status: 'draft' },
      { transaction: t }
    );

    for (const item of items) {
      const subtotal = parseFloat(item.qty) * parseFloat(item.unit_price || 0);
      await PurchaseReturnItem.create(
        {
          purchaseReturnId: pr.id,
          barangId: item.barangId,
          qty: item.qty,
          unit_price: item.unit_price || 0,
          subtotal,
          return_reason: item.return_reason || '',
        },
        { transaction: t }
      );
    }

    await t.commit();
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'purchase_return',
      pr.id,
      { kode: pr.kode, tanggal, goodReceiptId, catatan, return_reason, total_amount, itemsCount: items.length },
      req.ip || req.connection.remoteAddress
    );
    
    // Return with full data
    const result = await PurchaseReturn.findByPk(pr.id, {
      include: [
        {
          model: GoodReceipt,
          include: [
            {
              model: PurchaseOrder,
              include: [Supplier],
            },
          ],
        },
        {
          model: PurchaseReturnItem,
          as: 'items',
          include: [Barang],
        },
      ],
    });

    res.status(201).json({ message: 'Purchase Return berhasil dibuat', data: result });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_RETURN',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal membuat retur', error: err.message });
  }
};

exports.update = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, catatan, return_reason, items } = req.body;
    const id = req.params.id;

    const purchaseReturn = await PurchaseReturn.findByPk(id, { transaction: t });
    if (!purchaseReturn) {
      return res.status(404).json({ message: 'Purchase Return tidak ditemukan' });
    }

    if (purchaseReturn.status === 'completed') {
      return res.status(400).json({ message: 'Cannot update completed purchase return' });
    }

    let total_amount = 0;
    if (items && Array.isArray(items)) {
      const gr = await GoodReceipt.findByPk(purchaseReturn.goodReceiptId, {
        include: [{ model: GoodReceiptItem, as: 'items' }],
        transaction: t,
      });

      for (const item of items) {
        const grItem = gr.items.find(i => i.barangId === item.barangId);
        if (!grItem) {
          throw new Error(`Barang dengan ID ${item.barangId} tidak ada di Good Receipt ini`);
        }
        const subtotal = parseFloat(item.qty) * parseFloat(item.unit_price || 0);
        total_amount += subtotal;
      }

      await PurchaseReturnItem.destroy({ 
        where: { purchaseReturnId: id }, 
        transaction: t 
      });

      for (const item of items) {
        const subtotal = parseFloat(item.qty) * parseFloat(item.unit_price || 0);
        await PurchaseReturnItem.create({
          purchaseReturnId: id,
          barangId: item.barangId,
          qty: item.qty,
          unit_price: item.unit_price || 0,
          subtotal,
          return_reason: item.return_reason || '',
        }, { transaction: t });
      }
    }

    await purchaseReturn.update({
      tanggal,
      catatan,
      return_reason,
      total_amount: items ? total_amount : purchaseReturn.total_amount,
    }, { transaction: t });

    await t.commit();
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'purchase_return',
      id,
      { tanggal, catatan, return_reason, total_amount },
      req.ip || req.connection.remoteAddress
    );
    res.json({ message: 'Purchase Return berhasil diupdate' });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_RETURN',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal update Purchase Return', error: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { status } = req.body;
    const id = req.params.id;

    const purchaseReturn = await PurchaseReturn.findByPk(id, {
      include: [{ model: PurchaseReturnItem, as: 'items' }],
      transaction: t,
    });

    if (!purchaseReturn) {
      return res.status(404).json({ message: 'Purchase Return tidak ditemukan' });
    }

    const validStatusTransitions = {
      'draft': ['approved'],
      'approved': ['completed'],
      'completed': []
    };

    if (!validStatusTransitions[purchaseReturn.status].includes(status)) {
      return res.status(400).json({ 
        message: `Cannot change status from ${purchaseReturn.status} to ${status}` 
      });
    }

    if (status === 'completed' && purchaseReturn.status === 'approved') {
      for (const item of purchaseReturn.items) {
        const stockGudangPusat = await StockGudangPusat.findOne({
          where: { barangId: item.barangId },
          transaction: t,
          lock: t.LOCK.UPDATE,
        });

        if (!stockGudangPusat) {
          throw new Error(`Stock tidak ditemukan untuk barang ID ${item.barangId} di gudang pusat`);
        }

        if (parseFloat(stockGudangPusat.stok) < parseFloat(item.qty)) {
          throw new Error(`Stock insufficient untuk barang ID ${item.barangId}`);
        }

        stockGudangPusat.stok = parseFloat(stockGudangPusat.stok) - parseFloat(item.qty);
        await stockGudangPusat.save({ transaction: t });
      }
    }

    await purchaseReturn.update({ status }, { transaction: t });
    await t.commit();
    // Log successful status update
    LogService.logUpdate(
      req.user?.id,
      'purchase_return',
      id,
      { status },
      req.ip || req.connection.remoteAddress
    );

    res.json({ 
      message: `Purchase Return status berhasil diubah ke ${status}`,
      data: purchaseReturn
    });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_RETURN',
      'UPDATE_STATUS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal update status', error: err.message });
  }
};

exports.delete = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const id = req.params.id;
    const purchaseReturn = await PurchaseReturn.findByPk(id, { transaction: t });
    
    if (!purchaseReturn) {
      return res.status(404).json({ message: 'Purchase Return tidak ditemukan' });
    }

    if (purchaseReturn.status === 'completed') {
      return res.status(400).json({ message: 'Cannot delete completed purchase return' });
    }

    await PurchaseReturn.destroy({ where: { id }, transaction: t });
    await t.commit();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'purchase_return',
      id,
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: 'Purchase Return berhasil dihapus' });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_RETURN',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal hapus Purchase Return', error: err.message });
  }
};

exports.getAvailableGoodReceipts = async (req, res) => {
  try {
    // First, let's check if there are any GoodReceipts at all
    const totalGoodReceipts = await GoodReceipt.count();
    console.log(`Total GoodReceipts in database: ${totalGoodReceipts}`);

    // Get all GoodReceipts with their items and related data (temporarily without status filter)
    const goodReceipts = await GoodReceipt.findAll({
      include: [
        {
          model: PurchaseOrder,
          include: [Supplier],
        },
        {
          model: GoodReceiptItem,
          as: 'items',
          include: [Barang],
        },
      ],
      order: [['createdAt', 'DESC']],
    });

    console.log(`Found ${goodReceipts.length} GoodReceipts with items`);

    // Filter GoodReceipts that have items available for return
    const availableGoodReceipts = [];
    
    for (const gr of goodReceipts) {
      console.log(`Processing GR ${gr.kode} (status: ${gr.status}) with ${gr.items?.length || 0} items`);
      const availableItems = [];
      
      for (const grItem of gr.items) {
        // Calculate total quantity already returned for this item
        const totalReturned = await PurchaseReturnItem.sum('qty', {
          include: [{
            model: PurchaseReturn,
            where: { goodReceiptId: gr.id }
          }]
        }) || 0;
        
        // Calculate remaining quantity available for return
        const remainingQty = parseFloat(grItem.qty_diterima) - totalReturned;
        
        console.log(`Item ${grItem.Barang?.nama}: received=${grItem.qty_diterima}, returned=${totalReturned}, remaining=${remainingQty}`);
        
        if (remainingQty > 0) {
          availableItems.push({
            ...grItem.toJSON(),
            remainingQty: remainingQty
          });
        }
      }
      
      // Only include GoodReceipt if it has items available for return
      if (availableItems.length > 0) {
        availableGoodReceipts.push({
          ...gr.toJSON(),
          items: availableItems
        });
        console.log(`GR ${gr.kode} has ${availableItems.length} items available for return`);
      } else {
        console.log(`GR ${gr.kode} has no items available for return`);
      }
    }

    console.log(`Total available GoodReceipts: ${availableGoodReceipts.length}`);

    if (availableGoodReceipts.length === 0) {
      return res.status(404).json({ message: 'Data tidak ditemukan' });
    }

    res.json(availableGoodReceipts);
  } catch (err) {
    console.error('Error in getAvailableGoodReceipts:', err);
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PURCHASE_RETURN',
      'GET_AVAILABLE_GOOD_RECEIPTS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data Good Receipt', error: err.message });
  }
};