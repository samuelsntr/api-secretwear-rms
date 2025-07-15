const { Supplier } = require('../models');
const { Op } = require("sequelize");
const LogService = require('../services/logService');

// GET Semua Supplier
exports.getAllSupplier = async (req, res) => {
  try {
    const { search } = req.query;

    const whereClause = {};

    if (search) {
      whereClause.nama = {
        [Op.like]: `%${search}%`
      };
    }

    const suppliers = await Supplier.findAll({
      where: whereClause,
      order: [['createdAt', 'DESC']]
    });

    res.json(suppliers);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SUPPLIER',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data supplier', error: err.message });
  }
};

// GET Supplier berdasarkan ID
exports.getSupplierById = async (req, res) => {
  try {
    const supplier = await Supplier.findByPk(req.params.id);
    if (!supplier) {
      return res.status(404).json({ message: 'Supplier tidak ditemukan' });
    }
    res.json(supplier);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SUPPLIER',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil supplier', error: err.message });
  }
};

// POST Tambah Supplier
exports.createSupplier = async (req, res) => {
  try {
    const { nama, kontak, alamat } = req.body;
    const supplier = await Supplier.create({ nama, kontak, alamat });
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'supplier',
      supplier.id,
      { nama, kontak, alamat },
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json({ message: 'Supplier berhasil ditambahkan', supplier });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SUPPLIER',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menambah supplier', error: err.message });
  }
};

// PUT Update Supplier
exports.updateSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    const { nama, kontak, alamat } = req.body;
    const supplier = await Supplier.findByPk(id);

    if (!supplier) {
      return res.status(404).json({ message: 'Supplier tidak ditemukan' });
    }

    const oldData = {
      nama: supplier.nama,
      kontak: supplier.kontak,
      alamat: supplier.alamat
    };

    await supplier.update({ nama, kontak, alamat });
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'supplier',
      supplier.id,
      oldData,
      { nama, kontak, alamat },
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Supplier berhasil diperbarui', supplier });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SUPPLIER',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal memperbarui supplier', error: err.message });
  }
};

// DELETE Hapus Supplier
exports.deleteSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    const supplier = await Supplier.findByPk(id);

    if (!supplier) {
      return res.status(404).json({ message: 'Supplier tidak ditemukan' });
    }

    const supplierData = {
      id: supplier.id,
      nama: supplier.nama,
      kontak: supplier.kontak,
      alamat: supplier.alamat
    };

    await supplier.destroy();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'supplier',
      supplier.id,
      supplierData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Supplier berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SUPPLIER',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menghapus supplier', error: err.message });
  }
};
