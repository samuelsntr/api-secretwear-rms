const { StockGudangToko, Barang, Kategori, Warna, Ukuran } = require('../models');
const { Op } = require('sequelize');
const LogService = require('../services/logService');

// GET semua stok gudang toko dengan pagination dan search
exports.getAllStockGudangToko = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', storeId } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    
    // Add store filter
    if (storeId) {
      whereClause.storeId = storeId;
    }
    
    if (search) {
      whereClause = {
        ...whereClause,
        [Op.or]: [
          { '$Barang.nama$': { [Op.like]: `%${search}%` } },
          { '$Barang.sku$': { [Op.like]: `%${search}%` } },
          { '$Barang.barcode$': { [Op.like]: `%${search}%` } },
          { '$Barang.Kategori.nama$': { [Op.like]: `%${search}%` } },
          { '$Barang.Warna.nama$': { [Op.like]: `%${search}%` } },
          { '$Barang.Ukuran.nama$': { [Op.like]: `%${search}%` } },
          { storeId: { [Op.like]: `%${search}%` } }
        ]
      };
    }

    const { count, rows } = await StockGudangToko.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: Barang,
          include: [
            { model: Kategori },
            { model: Warna },
            { model: Ukuran }
          ]
        }
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['storeId', 'ASC'], ['createdAt', 'DESC']],
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
    res.status(500).json({ message: err.message });
  }
};

// GET detail stok gudang toko by ID
exports.getStockGudangTokoById = async (req, res) => {
  try {
    const stock = await StockGudangToko.findByPk(req.params.id, {
      include: [
        {
          model: Barang,
          include: [
            { model: Kategori },
            { model: Warna },
            { model: Ukuran }
          ]
        }
      ],
    });
    if (!stock) return res.status(404).json({ message: 'Stok tidak ditemukan' });
    res.json(stock);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// POST tambah stok gudang toko
exports.createStockGudangToko = async (req, res) => {
  try {
    const data = req.body;
    const stock = await StockGudangToko.create(data);
    res.status(201).json(stock);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// PUT update stok gudang toko
exports.updateStockGudangToko = async (req, res) => {
  try {
    const stock = await StockGudangToko.findByPk(req.params.id);
    if (!stock) return res.status(404).json({ message: 'Stok tidak ditemukan' });
    await stock.update(req.body);
    res.json(stock);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// DELETE stok gudang toko
exports.deleteStockGudangToko = async (req, res) => {
  try {
    const stock = await StockGudangToko.findByPk(req.params.id);
    if (!stock) return res.status(404).json({ message: 'Stok tidak ditemukan' });
    await stock.destroy();
    res.json({ message: 'Stok berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
}; 