const { SaleReturn, SaleReturnItem, Sale, Barang, User, StockGudangToko, SaleItem, Store, PaymentMethod, sequelize } = require("../models");
const { Op } = require("sequelize");
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

exports.getAll = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', status = '', startDate, endDate, storeId } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [Op.or]: [
          { kode: { [Op.like]: `%${search}%` } },
          { status: { [Op.like]: `%${search}%` } },
          { return_reason: { [Op.like]: `%${search}%` } }
        ]
      };
    }

    // Add status filter
    if (status) {
      whereClause.status = status;
    }

    // Add store filter for role-based access
    if (storeId) {
      whereClause.storeId = storeId;
    }

    // Add date filtering
    if (startDate || endDate) {
      const dateFilter = {};
      if (startDate) {
        dateFilter[Op.gte] = startDate;
      }
      if (endDate) {
        dateFilter[Op.lte] = endDate;
      }
      whereClause.tanggal = dateFilter;
    }

    const { count, rows } = await SaleReturn.findAndCountAll({
      where: whereClause,
      include: [
        { model: Sale, include: [
          { model: Store, as: 'store' },
          { model: PaymentMethod, as: 'paymentMethod' }
        ]},
        { model: User },
        { model: SaleReturnItem, as: 'items', include: [Barang] },
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
      'SALE_RETURN',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data', error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await SaleReturn.findByPk(req.params.id, {
      include: [
        { model: Sale, include: [
          { model: Store, as: 'store' },
          { model: PaymentMethod, as: 'paymentMethod' }
        ]},
        { model: User },
        { model: SaleReturnItem, as: 'items', include: [Barang] },
      ],
    });
    if (!data) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json(data);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SALE_RETURN',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil detail', error: err.message });
  }
};

// Helper function to calculate actual price paid for an item in a sale
const calculateActualPricePaid = (saleItem, sale) => {
  const qty = parseFloat(saleItem.qty);
  const harga = parseFloat(saleItem.harga);
  const subtotal = qty * harga;
  
  if (sale.discount_mode === 'item') {
    // Item discount: apply discount to this specific item
    const discount_percent = parseFloat(saleItem.discount_percent) || 0;
    const itemDiscount = subtotal * (discount_percent / 100);
    const itemTotal = subtotal - itemDiscount;
    return itemTotal / qty; // Return price per unit after discount
  } else if (sale.discount_mode === 'bill') {
    // Bill discount: calculate proportional discount for this item
    const billDiscountPercent = parseFloat(sale.bill_discount_percent) || 0;
    const itemDiscount = subtotal * (billDiscountPercent / 100);
    const itemTotal = subtotal - itemDiscount;
    return itemTotal / qty; // Return price per unit after discount
  }
  
  return harga; // No discount
};

exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, saleId, userId, storeId, return_reason, items } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items tidak boleh kosong' });
    }

    // Validate sale exists and get with items
    const sale = await Sale.findByPk(saleId, {
      include: [{ model: SaleItem, as: 'items' }],
      transaction: t,
    });
    if (!sale) {
      return res.status(404).json({ message: 'Sale tidak ditemukan' });
    }

    // Validate items are from the original sale and calculate actual prices
    const validatedItems = [];
    let total_return = 0;

    for (const item of items) {
      const originalItem = sale.items.find(si => si.barangId === item.barangId);
      if (!originalItem) {
        return res.status(400).json({ message: `Item dengan barangId ${item.barangId} tidak ada dalam sale` });
      }
      
      if (parseFloat(item.qty) > parseFloat(originalItem.qty)) {
        return res.status(400).json({ message: `Quantity return tidak boleh melebihi quantity original untuk barangId ${item.barangId}` });
      }

      // Calculate the actual price paid per unit (after discount)
      const actualPricePerUnit = calculateActualPricePaid(originalItem, sale);
      const returnQty = parseFloat(item.qty);
      const returnSubtotal = returnQty * actualPricePerUnit;
      
      total_return += returnSubtotal;

      validatedItems.push({
        ...item,
        actualPricePerUnit,
        returnSubtotal
      });
    }

    const kode = await generateCode('sale-return', t);

    const saleReturn = await SaleReturn.create({
      kode,
      tanggal,
      saleId,
      userId,
      storeId,
      total_return,
      return_reason,
      status: 'pending',
    }, { transaction: t });

    for (const item of validatedItems) {
      await SaleReturnItem.create({
        saleReturnId: saleReturn.id,
        barangId: item.barangId,
        qty: item.qty,
        harga: item.actualPricePerUnit, // Use the actual discounted price
        subtotal: item.returnSubtotal,
        return_reason: item.return_reason,
      }, { transaction: t });
    }

    await t.commit();
    
    // Log successful creation
    LogService.logCreate(
      req.user?.id,
      'sale_return',
      saleReturn.id,
      { kode: saleReturn.kode, tanggal, saleId, userId, storeId, return_reason, total_return, itemsCount: items.length },
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json({ 
      message: 'Sales return berhasil dibuat', 
      data: saleReturn,
      discountInfo: {
        originalSaleDiscountMode: sale.discount_mode,
        originalSaleBillDiscountPercent: sale.bill_discount_percent,
        itemsWithDiscountedPrices: validatedItems.map(item => ({
          barangId: item.barangId,
          originalPrice: sale.items.find(si => si.barangId === item.barangId).harga,
          discountedPrice: item.actualPricePerUnit,
          returnQty: item.qty,
          returnSubtotal: item.returnSubtotal
        }))
      }
    });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SALE_RETURN',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal membuat sales return', error: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { status } = req.body;
    const saleReturn = await SaleReturn.findByPk(req.params.id, {
      include: [{ model: SaleReturnItem, as: 'items' }],
      transaction: t,
    });

    if (!saleReturn) {
      return res.status(404).json({ message: 'Sales return tidak ditemukan' });
    }

    // If status is being changed to 'completed', add stock back to store
    if (status === 'completed' && saleReturn.status !== 'completed') {
      for (const item of saleReturn.items) {
        // Add stock back to StockGudangToko
        let stokToko = await StockGudangToko.findOne({
          where: { barangId: item.barangId, storeId: saleReturn.storeId },
          transaction: t,
          lock: t.LOCK.UPDATE,
        });

        if (!stokToko) {
          // Create new stock record if it doesn't exist
          stokToko = await StockGudangToko.create({
            barangId: item.barangId,
            storeId: saleReturn.storeId,
            stok: item.qty,
          }, { transaction: t });
        } else {
          stokToko.stok = parseFloat(stokToko.stok) + parseFloat(item.qty);
          await stokToko.save({ transaction: t });
        }
      }
    }

    saleReturn.status = status;
    await saleReturn.save({ transaction: t });

    await t.commit();
    res.json({ message: 'Status sales return berhasil diupdate', data: saleReturn });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SALE_RETURN',
      'UPDATE_STATUS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal update status', error: err.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const retur = await SaleReturn.findByPk(req.params.id);
    if (!retur) return res.status(404).json({ message: "Data tidak ditemukan" });

    await SaleReturn.destroy({ where: { id: req.params.id } });

    res.json({ message: "Data retur berhasil dihapus" });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SALE_RETURN',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: "Gagal menghapus retur", error: err.message });
  }
};

exports.getAvailableSales = async (req, res) => {
  try {
    const user = req.session.user;
    let whereClause = {};

    // Filter sales based on user role
    if (user.role === 'staff_sales') {
      // Staff sales can only see sales from their assigned store
      whereClause.storeId = user.storeId;
    }
    // Admin and owner can see all sales (no filter needed)

    const sales = await Sale.findAll({
      where: whereClause,
      include: [
        { model: User },
        { model: Store, as: 'store' },
        { model: PaymentMethod, as: 'paymentMethod' },
        { model: SaleItem, as: 'items', include: [Barang] },
      ],
      order: [['createdAt', 'DESC']],
    });
    
    // Enhance response with discount information for frontend
    const enhancedSales = sales.map(sale => {
      const saleData = sale.toJSON();
      saleData.discountInfo = {
        mode: sale.discount_mode,
        billDiscountPercent: sale.bill_discount_percent,
        hasDiscount: sale.discount_mode === 'bill' ? sale.bill_discount_percent > 0 : 
                    sale.items.some(item => item.discount_percent > 0)
      };
      return saleData;
    });
    
    res.json(enhancedSales);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SALE_RETURN',
      'GET_AVAILABLE_SALES',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data sales', error: err.message });
  }
};

// New endpoint to get sale details with calculated discounted prices
exports.getSaleWithDiscountedPrices = async (req, res) => {
  try {
    const { saleId } = req.params;
    
    const sale = await Sale.findByPk(saleId, {
      include: [
        { model: User },
        { model: Store, as: 'store' },
        { model: PaymentMethod, as: 'paymentMethod' },
        { model: SaleItem, as: 'items', include: [Barang] },
      ],
    });
    
    if (!sale) {
      return res.status(404).json({ message: 'Sale tidak ditemukan' });
    }

    // Calculate actual prices paid for each item
    const itemsWithDiscountedPrices = sale.items.map(item => {
      const actualPricePerUnit = calculateActualPricePaid(item, sale);
      return {
        ...item.toJSON(),
        originalPrice: item.harga,
        actualPricePerUnit,
        totalPaid: parseFloat(item.qty) * actualPricePerUnit,
        discountApplied: item.harga - actualPricePerUnit
      };
    });

    const response = {
      ...sale.toJSON(),
      items: itemsWithDiscountedPrices,
      discountInfo: {
        mode: sale.discount_mode,
        billDiscountPercent: sale.bill_discount_percent,
        hasDiscount: sale.discount_mode === 'bill' ? sale.bill_discount_percent > 0 : 
                    sale.items.some(item => item.discount_percent > 0)
      }
    };

    res.json(response);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'SALE_RETURN',
      'GET_SALE_WITH_DISCOUNTED_PRICES',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil detail sale', error: err.message });
  }
};
