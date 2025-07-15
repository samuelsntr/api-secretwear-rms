const { Store } = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

// GET all stores
exports.getAll = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', is_aktif } = req.query;
    const offset = (page - 1) * limit;
    
    let whereClause = {};
    
    if (search) {
      whereClause = {
        [Op.or]: [
          { nama: { [Op.like]: `%${search}%` } },
          { kode: { [Op.like]: `%${search}%` } },
          { manager: { [Op.like]: `%${search}%` } },
        ]
      };
    }
    
    if (is_aktif !== undefined) {
      whereClause.is_aktif = is_aktif === 'true';
    }

    const { count, rows } = await Store.findAndCountAll({
      where: whereClause,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']],
    });

    res.json({
      data: rows,
      pagination: {
        total: count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(count / limit),
      },
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data store', error: err.message });
  }
};

// GET store by ID
exports.getById = async (req, res) => {
  try {
    const store = await Store.findByPk(req.params.id);
    if (!store) {
      return res.status(404).json({ message: 'Store tidak ditemukan' });
    }
    res.json(store);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil detail store', error: err.message });
  }
};

// GET all active stores (for dropdowns)
exports.getActiveStores = async (req, res) => {
  try {
    const stores = await Store.findAll({
      where: { is_aktif: true },
      order: [['nama', 'ASC']],
      attributes: ['id', 'kode', 'nama', 'alamat', 'telepon', 'manager'],
    });
    res.json(stores);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'GET_ACTIVE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data store aktif', error: err.message });
  }
};

// POST create new store
exports.create = async (req, res) => {
  try {
    const { nama, alamat, telepon, email, manager, catatan } = req.body;
    
    if (!nama) {
      return res.status(400).json({ message: 'Nama store wajib diisi' });
    }

    const kode = await generateCode('store');
    
    const store = await Store.create({
      kode,
      nama,
      alamat,
      telepon,
      email,
      manager,
      catatan,
      is_aktif: true,
    });

    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'store',
      store.id,
      { kode, nama, alamat, telepon, email, manager, catatan },
      req.ip || req.connection.remoteAddress
    );

    res.status(201).json({ 
      message: 'Store berhasil dibuat', 
      data: store 
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    if (err.name === 'SequelizeUniqueConstraintError') {
      res.status(400).json({ message: 'Kode store sudah ada' });
    } else {
      res.status(500).json({ message: 'Gagal membuat store', error: err.message });
    }
  }
};

// PUT update store
exports.update = async (req, res) => {
  try {
    const { nama, alamat, telepon, email, manager, catatan, is_aktif } = req.body;
    
    const store = await Store.findByPk(req.params.id);
    if (!store) {
      return res.status(404).json({ message: 'Store tidak ditemukan' });
    }

    if (!nama) {
      return res.status(400).json({ message: 'Nama store wajib diisi' });
    }

    const oldData = {
      nama: store.nama,
      alamat: store.alamat,
      telepon: store.telepon,
      email: store.email,
      manager: store.manager,
      catatan: store.catatan,
      is_aktif: store.is_aktif
    };

    await store.update({
      nama,
      alamat,
      telepon,
      email,
      manager,
      catatan,
      is_aktif,
    });

    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'store',
      store.id,
      oldData,
      { nama, alamat, telepon, email, manager, catatan, is_aktif },
      req.ip || req.connection.remoteAddress
    );

    res.json({ 
      message: 'Store berhasil diperbarui', 
      data: store 
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal memperbarui store', error: err.message });
  }
};

// DELETE store
exports.delete = async (req, res) => {
  try {
    const store = await Store.findByPk(req.params.id);
    if (!store) {
      return res.status(404).json({ message: 'Store tidak ditemukan' });
    }

    // Check if store has related data
    const hasSales = await store.countSales();
    const hasSaleReturns = await store.countSaleReturns();
    const hasStockGudangToko = await store.countStockGudangTokos();
    const hasStockRequests = await store.countStockRequests();
    const hasStockTransfers = await store.countStockTransfers();

    if (hasSales > 0 || hasSaleReturns > 0 || hasStockGudangToko > 0 || 
        hasStockRequests > 0 || hasStockTransfers > 0) {
      return res.status(400).json({ 
        message: 'Store tidak dapat dihapus karena memiliki data terkait. Gunakan fitur nonaktifkan sebagai gantinya.' 
      });
    }

    const storeData = {
      id: store.id,
      kode: store.kode,
      nama: store.nama,
      alamat: store.alamat,
      telepon: store.telepon,
      email: store.email,
      manager: store.manager,
      catatan: store.catatan,
      is_aktif: store.is_aktif
    };

    await store.destroy();

    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'store',
      store.id,
      storeData,
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: 'Store berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menghapus store', error: err.message });
  }
};

// PATCH toggle store status
exports.toggleStatus = async (req, res) => {
  try {
    const store = await Store.findByPk(req.params.id);
    if (!store) {
      return res.status(404).json({ message: 'Store tidak ditemukan' });
    }

    const oldStatus = store.is_aktif;
    store.is_aktif = !store.is_aktif;
    await store.save();

    // Log status change
    LogService.logUpdate(
      req.user?.id,
      'store',
      store.id,
      { is_aktif: oldStatus },
      { is_aktif: store.is_aktif },
      req.ip || req.connection.remoteAddress
    );

    res.json({ 
      message: `Store berhasil ${store.is_aktif ? 'diaktifkan' : 'dinonaktifkan'}`, 
      data: store 
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STORE',
      'TOGGLE_STATUS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengubah status store', error: err.message });
  }
}; 