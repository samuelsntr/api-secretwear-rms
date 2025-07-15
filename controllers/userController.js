const { User, Store } = require('../models');
const bcrypt = require('bcrypt');
const LogService = require('../services/logService');

// Ambil semua user (tanpa password) dalam urutan tanggal
exports.getUsers = async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: ['id', 'username', 'role', 'storeId'],
      include: [
        {
          model: Store,
          attributes: ['id', 'nama'],
          required: false
        }
      ],
      order: [['createdAt', 'DESC']]
    });
    res.json(users);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'USER',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data user', error: err.message });
  }
};

// Tambah user baru
exports.createUser = async (req, res) => {
  try {
    const { username, password, role, storeId } = req.body;

    const existing = await User.findOne({ where: { username } });
    if (existing) return res.status(409).json({ message: 'Username sudah dipakai' });

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await User.create({
      username,
      password: hashedPassword,
      role,
      storeId: storeId || null
    });

    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'user',
      newUser.id,
      { username, role, storeId },
      req.ip || req.connection.remoteAddress
    );

    res.status(201).json({ 
      message: 'User berhasil dibuat', 
      user: { 
        id: newUser.id, 
        username: newUser.username, 
        role: newUser.role,
        storeId: newUser.storeId
      } 
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'USER',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal membuat user', error: err.message });
  }
};

// Edit username dan role (tidak ubah password)
exports.updateUser = async (req, res) => {
  try {
    const { username, role, password, storeId } = req.body;
    const user = await User.findByPk(req.params.id);

    if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

    const oldData = {
      username: user.username,
      role: user.role,
      storeId: user.storeId
    };

    user.username = username;
    user.role = role;
    user.storeId = storeId || null;

    if (password && password.trim() !== "") {
      const hashed = await bcrypt.hash(password, 10);
      user.password = hashed;
    }

    await user.save();

    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'user',
      user.id,
      oldData,
      { username, role, storeId },
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: 'User berhasil diupdate' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'USER',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal update user', error: err.message });
  }
};

// Hapus user
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

    const userData = {
      id: user.id,
      username: user.username,
      role: user.role,
      storeId: user.storeId
    };

    await user.destroy();

    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'user',
      user.id,
      userData,
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: 'User berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'USER',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menghapus user', error: err.message });
  }
};
