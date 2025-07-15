const { Kategori } = require('../models');
const { Op } = require('sequelize');
const LogService = require('../services/logService');

exports.getAllKategori = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        nama: { [Op.like]: `%${search}%` }
      };
    }

    const { count, rows } = await Kategori.findAndCountAll({
      where: whereClause,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['nama', 'ASC']],
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
      'KATEGORI',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

exports.getKategoriById = async (req, res) => {
  try {
    const kategori = await Kategori.findByPk(req.params.id);
    if (!kategori) return res.status(404).json({ message: 'Kategori tidak ditemukan' });
    res.json(kategori);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'KATEGORI',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

exports.createKategori = async (req, res) => {
  try {
    const kategori = await Kategori.create(req.body);
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'kategori',
      kategori.id,
      req.body,
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(kategori);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'KATEGORI',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

exports.updateKategori = async (req, res) => {
  try {
    const kategori = await Kategori.findByPk(req.params.id);
    if (!kategori) return res.status(404).json({ message: 'Kategori tidak ditemukan' });

    const oldData = {
      nama: kategori.nama,
      deskripsi: kategori.deskripsi
    };

    await kategori.update(req.body);
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'kategori',
      kategori.id,
      oldData,
      req.body,
      req.ip || req.connection.remoteAddress
    );
    
    res.json(kategori);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'KATEGORI',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

exports.deleteKategori = async (req, res) => {
  try {
    const kategori = await Kategori.findByPk(req.params.id);
    if (!kategori) return res.status(404).json({ message: 'Kategori tidak ditemukan' });

    const kategoriData = {
      id: kategori.id,
      nama: kategori.nama,
      deskripsi: kategori.deskripsi
    };

    await kategori.destroy();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'kategori',
      kategori.id,
      kategoriData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Kategori berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'KATEGORI',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};
