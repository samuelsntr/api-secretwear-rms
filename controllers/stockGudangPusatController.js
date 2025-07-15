const { StockGudangPusat, Barang, Kategori, Warna, Ukuran } = require('../models');
const { Op } = require('sequelize');
const LogService = require('../services/logService');

// GET semua stok gudang pusat dengan pagination dan search
exports.getAllStockGudangPusat = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [Op.or]: [
          { '$Barang.nama$': { [Op.like]: `%${search}%` } },
          { '$Barang.sku$': { [Op.like]: `%${search}%` } },
          { '$Barang.barcode$': { [Op.like]: `%${search}%` } },
          { '$Barang.Kategori.nama$': { [Op.like]: `%${search}%` } },
          { '$Barang.Warna.nama$': { [Op.like]: `%${search}%` } },
          { '$Barang.Ukuran.nama$': { [Op.like]: `%${search}%` } }
        ]
      };
    }

    const { count, rows } = await StockGudangPusat.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: Barang,
          include: [
            { model: Kategori },
            { model: Warna },
            { model: Ukuran }
          ]
        }
      ],
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
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_GUDANG_PUSAT',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// GET detail stok gudang pusat by ID
exports.getStockGudangPusatById = async (req, res) => {
  try {
    const stock = await StockGudangPusat.findByPk(req.params.id, {
      include: [
        {
          model: Barang,
          include: [
            { model: Kategori },
            { model: Warna },
            { model: Ukuran }
          ]
        }
      ],
    });
    if (!stock) return res.status(404).json({ message: 'Stok tidak ditemukan' });
    res.json(stock);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_GUDANG_PUSAT',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// POST tambah stok gudang pusat
exports.createStockGudangPusat = async (req, res) => {
  try {
    const data = req.body;
    
    // Validate stock limits if provided
    if (data.maximum_stock !== undefined && data.minimum_stock !== undefined) {
      if (data.maximum_stock <= data.minimum_stock) {
        return res.status(400).json({ 
          message: 'Maximum stock harus lebih besar dari minimum stock' 
        });
      }
    }
    
    if (data.maximum_stock !== undefined && data.maximum_stock < 0) {
      return res.status(400).json({ 
        message: 'Maximum stock tidak boleh negatif' 
      });
    }
    
    if (data.minimum_stock !== undefined && data.minimum_stock < 0) {
      return res.status(400).json({ 
        message: 'Minimum stock tidak boleh negatif' 
      });
    }
    
    const stock = await StockGudangPusat.create(data);
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'stock_gudang_pusat',
      stock.id,
      data,
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(stock);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_GUDANG_PUSAT',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

// PUT update stok gudang pusat
exports.updateStockGudangPusat = async (req, res) => {
  try {
    const stock = await StockGudangPusat.findByPk(req.params.id);
    if (!stock) return res.status(404).json({ message: 'Stok tidak ditemukan' });

    const data = req.body;
    
    // Validate stock limits if provided
    if (data.maximum_stock !== undefined && data.minimum_stock !== undefined) {
      if (data.maximum_stock <= data.minimum_stock) {
        return res.status(400).json({ 
          message: 'Maximum stock harus lebih besar dari minimum stock' 
        });
      }
    }
    
    if (data.maximum_stock !== undefined && data.maximum_stock < 0) {
      return res.status(400).json({ 
        message: 'Maximum stock tidak boleh negatif' 
      });
    }
    
    if (data.minimum_stock !== undefined && data.minimum_stock < 0) {
      return res.status(400).json({ 
        message: 'Minimum stock tidak boleh negatif' 
      });
    }

    const oldData = {
      stok: stock.stok,
      minimum_stock: stock.minimum_stock,
      maximum_stock: stock.maximum_stock
    };

    await stock.update(data);
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'stock_gudang_pusat',
      stock.id,
      oldData,
      data,
      req.ip || req.connection.remoteAddress
    );
    
    res.json(stock);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_GUDANG_PUSAT',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

// GET stok gudang pusat yang di bawah minimum stock
exports.getLowStockGudangPusat = async (req, res) => {
  try {
    const lowStock = await StockGudangPusat.findAll({
      include: [
        {
          model: Barang,
          include: [
            { model: Kategori },
            { model: Warna },
            { model: Ukuran }
          ]
        }
      ],
      where: {
        minimum_stock: {
          [Op.not]: null
        },
        stok: {
          [Op.lte]: require('sequelize').col('minimum_stock')
        }
      },
      order: [['stok', 'ASC']],
    });
    res.json(lowStock);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_GUDANG_PUSAT',
      'GET_LOW_STOCK',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// DELETE stok gudang pusat
exports.deleteStockGudangPusat = async (req, res) => {
  try {
    const stock = await StockGudangPusat.findByPk(req.params.id);
    if (!stock) return res.status(404).json({ message: 'Stok tidak ditemukan' });

    const stockData = {
      id: stock.id,
      barangId: stock.barangId,
      stok: stock.stok,
      minimum_stock: stock.minimum_stock,
      maximum_stock: stock.maximum_stock
    };

    await stock.destroy();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'stock_gudang_pusat',
      stock.id,
      stockData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Stok berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_GUDANG_PUSAT',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
}; 