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

// Get default permission configuration
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

exports.getDefaultPermissionsPreset = (req, res) => {
  const { role } = req.query;
  return res.json(getDefaultPermissions(role));
};

exports.getUserPermissions = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

    let permissions = user.permissions;
    if (typeof permissions === 'string') {
      try { permissions = JSON.parse(permissions); } catch(e) {}
    }
    
    if (!permissions || !permissions.actions || !permissions.menus) {
      permissions = getDefaultPermissions(user.role);
    } else {
      const defaults = getDefaultPermissions(user.role);
      permissions = {
        actions: { ...defaults.actions, ...permissions.actions },
        menus: { ...defaults.menus, ...permissions.menus }
      };
    }

    res.json({
      userId: user.id,
      username: user.username,
      role: user.role,
      permissions
    });
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'USER',
      'GET_PERMISSIONS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil hak akses', error: err.message });
  }
};

exports.updateUserPermissions = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

    const { actions, menus } = req.body;
    const oldPermissions = user.permissions;

    user.permissions = {
      actions: actions || {},
      menus: menus || {}
    };

    await user.save();

    LogService.logUpdate(
      req.user?.id,
      'user_permissions',
      user.id,
      { permissions: oldPermissions },
      { permissions: user.permissions },
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: 'Hak akses berhasil disimpan' });
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'USER',
      'UPDATE_PERMISSIONS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menyimpan hak akses', error: err.message });
  }
};
