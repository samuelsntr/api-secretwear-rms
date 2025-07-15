const { Ukuran } = require('../models');
const { Op } = require('sequelize');
const LogService = require('../services/logService');

exports.getAllUkuran = async (req, res) => {
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

    const { count, rows } = await Ukuran.findAndCountAll({
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
      'UKURAN',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

exports.getUkuranById = async (req, res) => {
  try {
    const ukuran = await Ukuran.findByPk(req.params.id);
    if (!ukuran) return res.status(404).json({ message: 'Ukuran tidak ditemukan' });
    res.json(ukuran);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'UKURAN',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

exports.createUkuran = async (req, res) => {
  try {
    const ukuran = await Ukuran.create(req.body);
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'ukuran',
      ukuran.id,
      req.body,
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(ukuran);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'UKURAN',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

exports.updateUkuran = async (req, res) => {
  try {
    const ukuran = await Ukuran.findByPk(req.params.id);
    if (!ukuran) return res.status(404).json({ message: 'Ukuran tidak ditemukan' });

    const oldData = {
      nama: ukuran.nama,
      deskripsi: ukuran.deskripsi
    };

    await ukuran.update(req.body);
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'ukuran',
      ukuran.id,
      oldData,
      req.body,
      req.ip || req.connection.remoteAddress
    );
    
    res.json(ukuran);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'UKURAN',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

exports.deleteUkuran = async (req, res) => {
  try {
    const ukuran = await Ukuran.findByPk(req.params.id);
    if (!ukuran) return res.status(404).json({ message: 'Ukuran tidak ditemukan' });

    const ukuranData = {
      id: ukuran.id,
      nama: ukuran.nama,
      deskripsi: ukuran.deskripsi
    };

    await ukuran.destroy();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'ukuran',
      ukuran.id,
      ukuranData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Ukuran berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'UKURAN',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};
