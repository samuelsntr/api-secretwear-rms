const { Warna } = require('../models');
const { Op } = require('sequelize');
const LogService = require('../services/logService');

exports.getAllWarna = async (req, res) => {
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

    const { count, rows } = await Warna.findAndCountAll({
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
      'WARNA',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

exports.getWarnaById = async (req, res) => {
  try {
    const warna = await Warna.findByPk(req.params.id);
    if (!warna) return res.status(404).json({ message: 'Warna tidak ditemukan' });
    res.json(warna);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'WARNA',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

exports.createWarna = async (req, res) => {
  try {
    const warna = await Warna.create(req.body);
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'warna',
      warna.id,
      req.body,
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(warna);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'WARNA',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

exports.updateWarna = async (req, res) => {
  try {
    const warna = await Warna.findByPk(req.params.id);
    if (!warna) return res.status(404).json({ message: 'Warna tidak ditemukan' });

    const oldData = {
      nama: warna.nama,
      deskripsi: warna.deskripsi
    };

    await warna.update(req.body);
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'warna',
      warna.id,
      oldData,
      req.body,
      req.ip || req.connection.remoteAddress
    );
    
    res.json(warna);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'WARNA',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

exports.deleteWarna = async (req, res) => {
  try {
    const warna = await Warna.findByPk(req.params.id);
    if (!warna) return res.status(404).json({ message: 'Warna tidak ditemukan' });

    const warnaData = {
      id: warna.id,
      nama: warna.nama,
      deskripsi: warna.deskripsi
    };

    await warna.destroy();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'warna',
      warna.id,
      warnaData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Warna berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'WARNA',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};
