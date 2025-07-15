const { StockRequest, StockRequestItem, Barang, Kategori, Warna, Ukuran } = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

// GET all stock requests with pagination, search, and date filtering
exports.getAllStockRequests = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', startDate, endDate } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [Op.or]: [
          { kode: { [Op.like]: `%${search}%` } },
          { fromWarehouse: { [Op.like]: `%${search}%` } },
          { status: { [Op.like]: `%${search}%` } }
        ]
      };
    }

    // Add date filtering
    if (startDate || endDate) {
      const dateFilter = {};
      if (startDate) {
        // Set start date to beginning of day (00:00:00)
        const startDateTime = new Date(startDate);
        startDateTime.setHours(0, 0, 0, 0);
        dateFilter[Op.gte] = startDateTime;
      }
      if (endDate) {
        // Add one day to include the end date
        const endDateTime = new Date(endDate);
        endDateTime.setDate(endDateTime.getDate() + 1);
        dateFilter[Op.lt] = endDateTime;
      }
      whereClause.createdAt = dateFilter;
    }

    const { count, rows } = await StockRequest.findAndCountAll({
      where: whereClause,
      include: [
        { 
          model: StockRequestItem, 
          as: 'items', 
          include: [{
            model: Barang,
            include: [
              { model: Kategori },
              { model: Warna },
              { model: Ukuran }
            ]
          }] 
        },
        { model: require('../models').Store, as: 'toStore' }
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
      'STOCK_REQUEST',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// GET stock request by ID
exports.getStockRequestById = async (req, res) => {
  try {
    const request = await StockRequest.findByPk(req.params.id, {
      include: [{ 
        model: StockRequestItem, 
        as: 'items', 
        include: [{
          model: Barang,
          include: [
            { model: Kategori },
            { model: Warna },
            { model: Ukuran }
          ]
        }] 
      }],
    });
    if (!request) return res.status(404).json({ message: 'Stock request not found' });
    res.json(request);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_REQUEST',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// POST create stock request with items
exports.createStockRequest = async (req, res) => {
  const t = await require('../models').sequelize.transaction();
  try {
    const { fromWarehouse, toStoreId, items } = req.body;
    
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items tidak boleh kosong' });
    }
    if (!toStoreId) {
      return res.status(400).json({ message: 'Store tujuan wajib dipilih' });
    }
    const kode = await generateCode('stock-request', t);
    
    const request = await StockRequest.create({ 
      kode,
      fromWarehouse, 
      toStoreId
    }, { transaction: t, returning: true });
    
    if (items && Array.isArray(items)) {
      for (const item of items) {
        await StockRequestItem.create({
          stockRequestId: request.id,
          barangId: item.barangId,
          qty: item.qty,
        }, { transaction: t });
      }
    }
    
    const result = await StockRequest.findByPk(request.id, {
      include: [
        { 
          model: StockRequestItem, 
          as: 'items', 
          include: [{
            model: Barang,
            include: [
              { model: Kategori },
              { model: Warna },
              { model: Ukuran }
            ]
          }] 
        },
        { model: require('../models').Store, as: 'toStore' }
      ],
      transaction: t
    });
    
    await t.commit();
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'stock_request',
      request.id,
      { kode: request.kode, fromWarehouse, toStoreId, itemsCount: items.length },
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(result);
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_REQUEST',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

// PUT update stock request with items
exports.updateStockRequest = async (req, res) => {
  const t = await require('../models').sequelize.transaction();
  try {
    const { fromWarehouse, toStoreId, items } = req.body;
    const id = req.params.id;

    const request = await StockRequest.findByPk(id);
    if (!request) {
      return res.status(404).json({ message: 'Stock request not found' });
    }

    // Check if request can be edited (only pending requests can be edited)
    if (request.status !== 'pending') {
      return res.status(400).json({ 
        message: 'Stock request hanya dapat diedit jika status masih pending' 
      });
    }

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items tidak boleh kosong' });
    }
    if (!toStoreId) {
      return res.status(400).json({ message: 'Store tujuan wajib dipilih' });
    }

    const oldData = {
      fromWarehouse: request.fromWarehouse,
      toStoreId: request.toStoreId,
      status: request.status
    };

    // Update basic fields
    await request.update({ 
      fromWarehouse, 
      toStoreId 
    }, { transaction: t });

    // Delete existing items and create new ones
    await StockRequestItem.destroy({ 
      where: { stockRequestId: id }, 
      transaction: t 
    });

    // Create new items
    for (const item of items) {
      await StockRequestItem.create({
        stockRequestId: id,
        barangId: item.barangId,
        qty: item.qty,
      }, { transaction: t });
    }

    const result = await StockRequest.findByPk(id, {
      include: [
        { 
          model: StockRequestItem, 
          as: 'items', 
          include: [{
            model: Barang,
            include: [
              { model: Kategori },
              { model: Warna },
              { model: Ukuran }
            ]
          }] 
        },
        { model: require('../models').Store, as: 'toStore' }
      ],
      transaction: t
    });

    await t.commit();
    
    // Log successful update
    LogService.logUpdate(
      req.user?.id,
      'stock_request',
      request.id,
      oldData,
      { fromWarehouse, toStoreId, itemsCount: items.length },
      req.ip || req.connection.remoteAddress
    );
    
    res.json(result);
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_REQUEST',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

// PUT update status of stock request
exports.updateStockRequestStatus = async (req, res) => {
  try {
    const request = await StockRequest.findByPk(req.params.id);
    if (!request) return res.status(404).json({ message: 'Stock request not found' });

    const oldStatus = request.status;
    request.status = req.body.status;
    await request.save();
    
    // Log successful status update
    LogService.logUpdate(
      req.user?.id,
      'stock_request',
      request.id,
      { status: oldStatus },
      { status: request.status },
      req.ip || req.connection.remoteAddress
    );
    
    res.json(request);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_REQUEST',
      'UPDATE_STATUS',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

// DELETE stock request (and items)
exports.deleteStockRequest = async (req, res) => {
  try {
    const request = await StockRequest.findByPk(req.params.id);
    if (!request) return res.status(404).json({ message: 'Stock request not found' });

    const requestData = {
      id: request.id,
      kode: request.kode,
      fromWarehouse: request.fromWarehouse,
      toStoreId: request.toStoreId,
      status: request.status
    };

    await request.destroy();
    
    // Log successful deletion
    LogService.logDelete(
      req.user?.id,
      'stock_request',
      request.id,
      requestData,
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ message: 'Stock request deleted' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_REQUEST',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
}; 