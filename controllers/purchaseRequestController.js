const { PurchaseRequest, PurchaseRequestItem, Barang, User, sequelize } = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

// GET all purchase requests with pagination, search, and date filtering
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

    const { count, rows } = await PurchaseRequest.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: PurchaseRequestItem,
          as: 'items',
          include: [{ model: Barang }],
        },
        {
          model: User,
          as: 'creator',
          attributes: ['username'],
        },
        {
          model: User,
          as: 'approver',
          attributes: ['username'],
        }
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
      'PURCHASE_REQUEST',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data', error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await PurchaseRequest.findByPk(req.params.id, {
      include: [
        {
          model: PurchaseRequestItem,
          as: 'items',
          include: [{ model: Barang }],
        },
        {
          model: User,
          as: 'creator',
          attributes: ['username'],
        }
      ],
    });
    if (!data) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json(data);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil detail', error: err.message });
  }
};

exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, catatan, created_by, items } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Item tidak boleh kosong' });
    }

    const kode = await generateCode('purchase-request', t);

    const pr = await PurchaseRequest.create({
      kode,
      tanggal,
      status: 'draft',
      catatan,
      created_by,
    }, { transaction: t });

    for (const item of items) {
      if (!item.barangId || !item.qty) {
        await t.rollback();
        return res.status(400).json({ message: 'Barang dan qty wajib diisi di setiap item' });
      }

      await PurchaseRequestItem.create({
        purchaseRequestId: pr.id,
        barangId: item.barangId,
        qty: item.qty,
        satuan: item.satuan,
        keterangan: item.keterangan,
      }, { transaction: t });
    }

    await t.commit();
    res.status(201).json({ message: 'Purchase Request berhasil dibuat', data: pr });
  } catch (err) {
    await t.rollback();
    res.status(500).json({ message: 'Gagal membuat purchase request', error: err.message });
  }
};

exports.update = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, catatan, status, items } = req.body;
    const id = req.params.id;

    const pr = await PurchaseRequest.findByPk(id);
    if (!pr) return res.status(404).json({ message: 'Data tidak ditemukan' });

    // Update basic fields
    await pr.update({ tanggal, catatan, status }, { transaction: t });

    // Only update items if items array is provided
    if (items && Array.isArray(items)) {
      // Hapus dan replace semua item
      await PurchaseRequestItem.destroy({ where: { purchaseRequestId: id }, transaction: t });

      for (const item of items) {
        await PurchaseRequestItem.create({
          purchaseRequestId: id,
          barangId: item.barangId,
          qty: item.qty,
          satuan: item.satuan,
          keterangan: item.keterangan,
        }, { transaction: t });
      }
    }

    await t.commit();
    res.json({ message: 'Berhasil update purchase request' });
  } catch (err) {
    await t.rollback();
    res.status(500).json({ message: 'Gagal update', error: err.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const id = req.params.id;
    const pr = await PurchaseRequest.findByPk(id);
    if (!pr) return res.status(404).json({ message: 'Data tidak ditemukan' });

    await PurchaseRequest.destroy({ where: { id } });
    res.json({ message: 'Berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal hapus', error: err.message });
  }
};

// POST approve or reject purchase request
exports.handleApproval = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { action, reason, userId } = req.body; // action: 'approve' or 'reject'
    const id = req.params.id;

    // Get the request with its items
    const pr = await PurchaseRequest.findByPk(id, {
      include: [{ model: PurchaseRequestItem, as: 'items' }],
    });
    
    if (!pr) {
      return res.status(404).json({ message: 'Purchase request tidak ditemukan' });
    }

    // Validate current status
    if (pr.status !== 'diajukan') {
      return res.status(400).json({ 
        message: 'Hanya purchase request dengan status "diajukan" yang dapat diproses' 
      });
    }

    // Get the user (owner)
    const user = await User.findByPk(userId);
    if (!user || user.role !== 'owner') { // Assuming 'admin' is owner role
      return res.status(403).json({ message: 'Unauthorized: Only owner can approve/reject' });
    }

    const now = new Date();

    if (action === 'approve') {
      await pr.update({
        status: 'disetujui',
        approved_by: userId,
        approved_at: now,
      }, { transaction: t });
    } else if (action === 'reject') {
      if (!reason) {
        return res.status(400).json({ message: 'Rejection reason is required' });
      }
      await pr.update({
        status: 'ditolak',
        approved_by: userId,
        approved_at: now,
        rejection_reason: reason,
      }, { transaction: t });
    } else {
      return res.status(400).json({ message: 'Invalid action. Use "approve" or "reject"' });
    }

    await t.commit();
    res.json({ 
      message: `Purchase request berhasil ${action === 'approve' ? 'disetujui' : 'ditolak'}`,
      data: pr
    });
  } catch (err) {
    await t.rollback();
    res.status(500).json({ message: 'Gagal memproses approval', error: err.message });
  }
};
