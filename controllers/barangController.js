const { Barang, Kategori, Warna, Ukuran } = require('../models');
const LogService = require('../services/logService');

// GET semua barang dengan relasi, search, dan pagination
exports.getAllBarang = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [require('sequelize').Op.or]: [
          { nama: { [require('sequelize').Op.like]: `%${search}%` } },
          { sku: { [require('sequelize').Op.like]: `%${search}%` } },
          { barcode: { [require('sequelize').Op.like]: `%${search}%` } },
          { '$Kategori.nama$': { [require('sequelize').Op.like]: `%${search}%` } },
          { '$Warna.nama$': { [require('sequelize').Op.like]: `%${search}%` } },
          { '$Ukuran.nama$': { [require('sequelize').Op.like]: `%${search}%` } }
        ]
      };
    }

    const { count, rows } = await Barang.findAndCountAll({
      where: whereClause,
      include: [Kategori, Warna, Ukuran],
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
    res.status(500).json({ message: err.message });
  }
};

// GET detail barang by ID
exports.getBarangById = async (req, res) => {
  try {
    const barang = await Barang.findByPk(req.params.id, {
      include: [Kategori, Warna, Ukuran],
    });
    if (!barang) return res.status(404).json({ message: 'Barang tidak ditemukan' });
    res.json(barang);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// POST tambah barang baru
exports.createBarang = async (req, res) => {
  try {
    const data = req.body;
    // Set harga_beli to 0 if empty string
    if (data.harga_beli === '') {
      data.harga_beli = 0;
    }
    const barang = await Barang.create(data);
    
    // Log the creation
    LogService.logCreate(
      req.user?.id,
      'barang',
      barang.id,
      data,
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(barang);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// PUT update barang
exports.updateBarang = async (req, res) => {
  try {
    const barang = await Barang.findByPk(req.params.id);
    if (!barang) return res.status(404).json({ message: 'Barang tidak ditemukan' });

    const oldData = barang.toJSON();
    const updateData = req.body;
    // Set harga_beli to 0 if empty string
    if (updateData.harga_beli === '') {
      updateData.harga_beli = 0;
    }
    await barang.update(updateData);
    
    // Log the update
    LogService.logUpdate(
      req.user?.id,
      'barang',
      barang.id,
      oldData,
      updateData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json(barang);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// DELETE barang
exports.deleteBarang = async (req, res) => {
  try {
    const barang = await Barang.findByPk(req.params.id);
    if (!barang) return res.status(404).json({ message: 'Barang tidak ditemukan' });

    const deletedData = barang.toJSON();
    await barang.destroy();
    
    // Log the deletion
    LogService.logDelete(
      req.user?.id,
      'barang',
      req.params.id,
      deletedData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Barang berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
