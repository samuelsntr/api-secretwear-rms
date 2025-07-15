const { User, Store } = require('../models');
const bcrypt = require('bcrypt');
const LogService = require('../services/logService');

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne({ 
      where: { username },
      include: [
        {
          model: Store,
          attributes: ['id', 'nama'],
          required: false
        }
      ]
    });
    if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ message: 'Password salah' });

    // Jika pakai session
    req.session.user = {
      id: user.id,
      username: user.username,
      role: user.role,
      storeId: user.storeId,
      store: user.Store ? {
        id: user.Store.id,
        nama: user.Store.nama
      } : null
    };

    // Log successful login
    LogService.logLogin(
      user.id,
      req.ip || req.connection.remoteAddress,
      req.get('User-Agent'),
      req.sessionID
    );

    res.json({ message: 'Login berhasil', user: req.session.user });
  } catch (err) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: err.message });
  }
};

exports.me = async (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ message: 'Belum login' });
  }

  // Get fresh user data with store information
  try {
    const user = await User.findByPk(req.session.user.id, {
      include: [
        {
          model: Store,
          attributes: ['id', 'nama'],
          required: false
        }
      ]
    });

    if (!user) {
      return res.status(404).json({ message: 'User tidak ditemukan' });
    }

    const userData = {
      id: user.id,
      username: user.username,
      role: user.role,
      storeId: user.storeId,
      store: user.Store ? {
        id: user.Store.id,
        nama: user.Store.nama
      } : null
    };

    // Update session with fresh data
    req.session.user = userData;
    res.json(userData);
  } catch (err) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: err.message });
  }
};

exports.register = async (req, res) => {
  const { username, password, role, storeId } = req.body;

  try {
    const existingUser = await User.findOne({ where: { username } });
    if (existingUser) return res.status(409).json({ message: 'User sudah ada' });

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await User.create({
      username,
      password: hashedPassword,
      role,
      storeId: storeId || null
    });

    res.status(201).json({ message: 'Register berhasil', user: newUser });
  } catch (err) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: err.message });
  }
};

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll({
      include: [
        {
          model: Store,
          attributes: ['id', 'nama'],
          required: false
        }
      ]
    });
    if (!users) return res.status(404).json({ message: 'Tidak ada user' });

    res.json({ message: 'Daftar user', users });
  } catch (err) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: err.message });
  }
};

// controllers/AuthController.js
exports.logout = (req, res) => {
  const userId = req.session.user?.id;
  
  req.session.destroy((err) => {
    if (err) {
      console.error("Gagal logout:", err);
      return res.status(500).json({ message: "Gagal logout" });
    }

    // Log logout
    LogService.logLogout(
      userId,
      req.ip || req.connection.remoteAddress,
      req.sessionID
    );

    // Hapus cookie di browser juga
    res.clearCookie("connect.sid"); // nama cookie default dari express-session
    res.json({ message: "Logout berhasil" });
  });
};

