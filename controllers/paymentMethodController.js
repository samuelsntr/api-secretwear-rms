const { PaymentMethod } = require("../models");
const { Op } = require("sequelize");
const LogService = require('../services/logService');

exports.getAll = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', is_aktif = '' } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [Op.or]: [
          { nama: { [Op.like]: `%${search}%` } },
          { deskripsi: { [Op.like]: `%${search}%` } }
        ]
      };
    }

    // Add active filter
    if (is_aktif !== '') {
      whereClause.is_aktif = is_aktif === 'true';
    }

    const { count, rows } = await PaymentMethod.findAndCountAll({
      where: whereClause,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [["createdAt", "DESC"]],
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
      'PAYMENT_METHOD',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal mengambil data", error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await PaymentMethod.findByPk(req.params.id);
    if (!data) return res.status(404).json({ message: "Data tidak ditemukan" });
    res.json(data);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PAYMENT_METHOD',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal mengambil detail", error: err.message });
  }
};

exports.create = async (req, res) => {
  try {
    const { nama, deskripsi, is_aktif = true } = req.body;
    
    if (!nama) {
      return res.status(400).json({ message: "Nama wajib diisi" });
    }

    // Check if nama already exists
    const existingPaymentMethod = await PaymentMethod.findOne({
      where: { nama: nama }
    });

    if (existingPaymentMethod) {
      return res.status(400).json({ message: "Nama payment method sudah ada" });
    }

    const data = await PaymentMethod.create({
      nama,
      deskripsi,
      is_aktif
    });

    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'payment_method',
      data.id,
      { nama, deskripsi, is_aktif },
      req.ip || req.connection.remoteAddress
    );

    res.status(201).json({
      message: "Payment method berhasil dibuat",
      data
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PAYMENT_METHOD',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal membuat data", error: err.message });
  }
};

exports.update = async (req, res) => {
  try {
    const { nama, deskripsi, is_aktif } = req.body;
    const { id } = req.params;

    const data = await PaymentMethod.findByPk(id);
    if (!data) {
      return res.status(404).json({ message: "Data tidak ditemukan" });
    }

    if (nama && nama !== data.nama) {
      // Check if nama already exists
      const existingPaymentMethod = await PaymentMethod.findOne({
        where: { 
          nama: nama,
          id: { [Op.ne]: id }
        }
      });

      if (existingPaymentMethod) {
        return res.status(400).json({ message: "Nama payment method sudah ada" });
      }
    }

    const oldData = {
      nama: data.nama,
      deskripsi: data.deskripsi,
      is_aktif: data.is_aktif
    };

    await data.update({
      nama: nama || data.nama,
      deskripsi: deskripsi !== undefined ? deskripsi : data.deskripsi,
      is_aktif: is_aktif !== undefined ? is_aktif : data.is_aktif
    });

    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'payment_method',
      data.id,
      oldData,
      { nama: data.nama, deskripsi: data.deskripsi, is_aktif: data.is_aktif },
      req.ip || req.connection.remoteAddress
    );

    res.json({
      message: "Payment method berhasil diperbarui",
      data
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PAYMENT_METHOD',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal memperbarui data", error: err.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await PaymentMethod.findByPk(id);
    
    if (!data) {
      return res.status(404).json({ message: "Data tidak ditemukan" });
    }

    const paymentMethodData = {
      id: data.id,
      nama: data.nama,
      deskripsi: data.deskripsi,
      is_aktif: data.is_aktif
    };

    await data.destroy();

    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'payment_method',
      data.id,
      paymentMethodData,
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: "Payment method berhasil dihapus" });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PAYMENT_METHOD',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal menghapus data", error: err.message });
  }
};

// Get active payment methods for dropdowns
exports.getActive = async (req, res) => {
  try {
    const data = await PaymentMethod.findAll({
      where: { is_aktif: true },
      order: [["nama", "ASC"]],
    });
    res.json(data);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'PAYMENT_METHOD',
      'GET_ACTIVE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal mengambil data", error: err.message });
  }
}; 