const { StockTransfer, StockTransferItem, StockRequest, Barang, StockGudangPusat, StockGudangToko, Kategori, Warna, Ukuran, Store } = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

// GET all stock transfers with pagination, search, and date filtering
exports.getAllStockTransfers = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', startDate, endDate } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    
    if (search) {
      // For now, only search in the main StockTransfer table
      // StockRequest fields will be searchable in the frontend
      whereClause = {
        [Op.or]: [
          { kode: { [Op.like]: `%${search}%` } },
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

    const { count, rows } = await StockTransfer.findAndCountAll({
      where: whereClause,
      include: [
        { 
          model: StockTransferItem, 
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
        { 
          model: StockRequest,
          include: [
            { model: Store, as: 'toStore' }
          ]
        },
        { model: Store, as: 'toStore' },
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
      'STOCK_TRANSFER',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// GET stock transfer by ID
exports.getStockTransferById = async (req, res) => {
  try {
    const transfer = await StockTransfer.findByPk(req.params.id, {
      include: [
        { 
          model: StockTransferItem, 
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
        { 
          model: StockRequest,
          include: [
            { model: Store, as: 'toStore' }
          ]
        },
        { model: Store, as: 'toStore' },
      ],
    });
    if (!transfer) return res.status(404).json({ message: 'Stock transfer not found' });
    res.json(transfer);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_TRANSFER',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// POST create stock transfer with items
exports.createStockTransfer = async (req, res) => {
  const t = await require('../models').sequelize.transaction();
  try {
    const { stockRequestId, items } = req.body;
    
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items tidak boleh kosong' });
    }

    // Validation: Only allow barang that exist in StockGudangPusat
    const barangIds = items.map(item => item.barangId);
    const pusatStocks = await StockGudangPusat.findAll({ where: { barangId: barangIds } });
    const pusatBarangIds = pusatStocks.map(s => s.barangId);
    const notExist = barangIds.filter(id => !pusatBarangIds.includes(id));
    if (notExist.length > 0) {
      return res.status(400).json({ message: `Barang berikut tidak ada di stok gudang pusat: ${notExist.join(', ')}` });
    }

    // Get the stock request to get the storeId
    const stockRequest = await StockRequest.findByPk(stockRequestId, { transaction: t });
    if (!stockRequest) {
      return res.status(404).json({ message: 'Stock request not found' });
    }

    const kode = await generateCode('stock-transfer', t);
    
    const transfer = await StockTransfer.create({ 
      kode,
      stockRequestId,
      storeId: stockRequest.toStoreId
    }, { transaction: t, returning: true });
    
    if (items && Array.isArray(items)) {
      for (const item of items) {
        await StockTransferItem.create({
          stockTransferId: transfer.id,
          barangId: item.barangId,
          qty: item.qty,
        }, { transaction: t });
      }
    }
    
    const result = await StockTransfer.findByPk(transfer.id, {
      include: [
        { 
          model: StockTransferItem, 
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
        { 
          model: StockRequest,
          include: [
            { model: Store, as: 'toStore' }
          ]
        },
        { model: Store, as: 'toStore' },
      ],
      transaction: t
    });
    
    await t.commit();
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'stock_transfer',
      transfer.id,
      { kode: transfer.kode, stockRequestId, storeId: stockRequest.toStoreId, itemsCount: items.length },
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json(result);
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_TRANSFER',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(400).json({ message: err.message });
  }
};

// PUT update status of stock transfer
exports.updateStockTransferStatus = async (req, res) => {
  const t = await require('../models').sequelize.transaction();
  try {
    const transfer = await StockTransfer.findByPk(req.params.id, {
      include: [
        { 
          model: StockTransferItem, 
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
        { 
          model: StockRequest,
          include: [
            { model: Store, as: 'toStore' }
          ]
        },
        { model: Store, as: 'toStore' },
      ],
      transaction: t
    });
    
    if (!transfer) {
      return res.status(404).json({ message: 'Stock transfer not found' });
    }

    const oldStatus = transfer.status;
    const newStatus = req.body.status;
    
    // Update transfer status
    await transfer.update({ status: newStatus }, { transaction: t });
    
    // If status is 'completed', update stock levels and stock request status
    if (newStatus === 'completed' && oldStatus !== 'completed') {
      // Update stock request status to fulfilled
      if (transfer.StockRequest) {
        await transfer.StockRequest.update({ status: 'fulfilled' }, { transaction: t });
      }
      
      for (const item of transfer.items) {
        // Deduct from central warehouse
        const centralStock = await StockGudangPusat.findOne({
          where: { barangId: item.barangId },
          transaction: t,
          lock: t.LOCK.UPDATE
        });
        
        if (centralStock) {
          centralStock.stok = parseFloat(centralStock.stok) - parseFloat(item.qty);
          await centralStock.save({ transaction: t });
        }
        
        // Add to store stock
        let storeStock = await StockGudangToko.findOne({
          where: { 
            barangId: item.barangId,
            storeId: transfer.storeId
          },
          transaction: t,
          lock: t.LOCK.UPDATE
        });
        
        if (storeStock) {
          storeStock.stok = parseFloat(storeStock.stok) + parseFloat(item.qty);
          await storeStock.save({ transaction: t });
        } else {
          // Create new store stock entry if it doesn't exist
          await StockGudangToko.create({
            barangId: item.barangId,
            storeId: transfer.storeId,
            stok: parseFloat(item.qty)
          }, { transaction: t });
        }
      }
    }
    
    await t.commit();
    
    // Log successful status update
    LogService.logUpdate(
      req.user?.id,
      'stock_transfer',
      transfer.id,
      { status: oldStatus },
      { status: newStatus },
      req.ip || req.connection.remoteAddress
    );
    
    res.json({ 
      message: `Stock transfer status updated to ${newStatus}`,
      data: transfer 
    });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'STOCK_TRANSFER',
      'UPDATE_STATUS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: err.message });
  }
};

// DELETE stock transfer (and items)
exports.deleteStockTransfer = async (req, res) => {
  try {
    const transfer = await StockTransfer.findByPk(req.params.id);
    if (!transfer) return res.status(404).json({ message: 'Stock transfer not found' });
    await transfer.destroy();
    res.json({ message: 'Stock transfer deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};