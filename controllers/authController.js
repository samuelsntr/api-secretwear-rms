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

    // Get and parse user permissions
    let userPermissions = user.permissions;
    if (typeof userPermissions === 'string') {
      try { userPermissions = JSON.parse(userPermissions); } catch(e) {}
    }
    if (!userPermissions || !userPermissions.actions || !userPermissions.menus) {
      userPermissions = getDefaultPermissions(user.role);
    } else {
      const defaults = getDefaultPermissions(user.role);
      userPermissions = {
        actions: { ...defaults.actions, ...userPermissions.actions },
        menus: { ...defaults.menus, ...userPermissions.menus }
      };
    }

    // Jika pakai session
    req.session.user = {
      id: user.id,
      username: user.username,
      role: user.role,
      storeId: user.storeId,
      permissions: userPermissions,
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

    // Get and parse user permissions
    let userPermissions = user.permissions;
    if (typeof userPermissions === 'string') {
      try { userPermissions = JSON.parse(userPermissions); } catch(e) {}
    }
    if (!userPermissions || !userPermissions.actions || !userPermissions.menus) {
      userPermissions = getDefaultPermissions(user.role);
    } else {
      const defaults = getDefaultPermissions(user.role);
      userPermissions = {
        actions: { ...defaults.actions, ...userPermissions.actions },
        menus: { ...defaults.menus, ...userPermissions.menus }
      };
    }

    const userData = {
      id: user.id,
      username: user.username,
      role: user.role,
      storeId: user.storeId,
      permissions: userPermissions,
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

const getDefaultPermissions = (role) => {
  const isOwner = role === 'owner';
  const isAdmin = role === 'admin' || isOwner;
  const isGudang = role === 'staff_gudang';
  const isSales = role === 'staff_sales';

  return {
    actions: {
      add: isAdmin || isGudang || isSales,
      update: isAdmin || isGudang,
      reprint: isAdmin || isSales,
      delete: isAdmin
    },
    menus: {
      master_barang: isAdmin || isGudang,
      master_supplier: isAdmin || isGudang,
      master_gudang: isAdmin,
      master_unit: isAdmin || isGudang,
      master_kategori: isAdmin || isGudang,
      master_brand: isAdmin || isGudang,
      
      pembelian: isAdmin || isGudang,
      retur_pembelian: isAdmin || isGudang,
      
      distribusi_transfer: isAdmin || isGudang,
      distribusi_penerimaan: isAdmin || isGudang || isSales,
      
      penjualan_pos: isAdmin || isSales,
      penjualan_retur: isAdmin || isSales,
      penjualan_closing: isAdmin || isSales,
      
      persediaan_stock: isAdmin || isGudang || isSales,
      persediaan_mutasi: isAdmin || isGudang,
      persediaan_opname: isAdmin || isGudang,
      
      laporan_penjualan: isAdmin || isOwner,
      laporan_setoran: isAdmin || isOwner || isSales,
      laporan_profit: isAdmin || isOwner,
      
      tools_users: isAdmin,
      tools_hak_akses: isAdmin
    }
  };
};

