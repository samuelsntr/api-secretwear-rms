const { Sale, SaleItem, Barang, User, StockGudangToko, PaymentMethod, sequelize } = require("../models");
const { Op } = require("sequelize");
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

exports.getAll = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', paymentMethodId = '', startDate, endDate, storeId } = req.query;
    const offset = (page - 1) * limit;
    
    // Build search conditions
    let whereClause = {};
    if (search) {
      whereClause = {
        [Op.or]: [
          { kode: { [Op.like]: `%${search}%` } },
          { catatan: { [Op.like]: `%${search}%` } }
        ]
      };
    }

    // Add payment method filter
    if (paymentMethodId) {
      whereClause.paymentMethodId = paymentMethodId;
    }

    // Add store filter
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

    const { count, rows } = await Sale.findAndCountAll({
      where: whereClause,
      include: [
        { model: User },
        { model: PaymentMethod, as: "paymentMethod" },
        { model: SaleItem, as: "items", include: [Barang] },
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [["createdAt", "DESC"]],
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
    res.status(500).json({ message: "Gagal mengambil data", error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await Sale.findByPk(req.params.id, {
      include: [
        { model: User },
        { model: PaymentMethod, as: "paymentMethod" },
        { model: SaleItem, as: "items", include: [Barang] },
      ],
    });
    if (!data) return res.status(404).json({ message: "Data tidak ditemukan" });
    res.json(data);
  } catch (err) {
    res.status(500).json({ message: "Gagal mengambil detail", error: err.message });
  }
};

exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const {
      tanggal,
      userId,
      storeId,
      paymentMethodId,
      catatan,
      items,
      discount_mode = 'item',
      bill_discount_percent = 0
    } = req.body;
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: "Items tidak boleh kosong" });
    }
    if (!storeId) {
      return res.status(400).json({ message: "storeId wajib diisi" });
    }
    if (discount_mode !== 'item' && discount_mode !== 'bill') {
      return res.status(400).json({ message: "discount_mode harus 'item' atau 'bill'" });
    }
    if (discount_mode === 'bill' && (bill_discount_percent < 0 || bill_discount_percent > 100)) {
      return res.status(400).json({ message: "bill_discount_percent harus antara 0-100" });
    }

    const kode = await generateCode('sale', t);
    let total = 0;
    let itemsTotal = 0;
    let billDiscount = 0;

    // Calculate totals based on discount mode
    if (discount_mode === 'item') {
      for (const item of items) {
        const qty = parseFloat(item.qty);
        const harga = parseFloat(item.harga);
        const discount_percent = parseFloat(item.discount_percent) || 0;
        if (discount_percent < 0 || discount_percent > 100) {
          await t.rollback();
          return res.status(400).json({ message: `discount_percent untuk item ${item.barangId} harus antara 0-100` });
        }
        const subtotal = qty * harga;
        const itemDiscount = subtotal * (discount_percent / 100);
        const itemTotal = subtotal - itemDiscount;
        itemsTotal += itemTotal;
      }
      total = itemsTotal;
    } else if (discount_mode === 'bill') {
      for (const item of items) {
        const qty = parseFloat(item.qty);
        const harga = parseFloat(item.harga);
        const subtotal = qty * harga;
        itemsTotal += subtotal;
      }
      billDiscount = itemsTotal * (parseFloat(bill_discount_percent) / 100);
      total = itemsTotal - billDiscount;
    }

    // Create Sale
    const sale = await Sale.create({
      kode,
      tanggal,
      userId,
      storeId,
      total,
      paymentMethodId,
      catatan,
      discount_mode,
      bill_discount_percent: discount_mode === 'bill' ? bill_discount_percent : 0,
    }, { transaction: t });

    // Create SaleItems
    for (const item of items) {
      const qty = parseFloat(item.qty);
      const harga = parseFloat(item.harga);
      const discount_percent = discount_mode === 'item' ? (parseFloat(item.discount_percent) || 0) : 0;
      const subtotal = qty * harga;
      const itemDiscount = discount_mode === 'item' ? subtotal * (discount_percent / 100) : 0;
      const itemTotal = subtotal - itemDiscount;
      await SaleItem.create({
        saleId: sale.id,
        barangId: item.barangId,
        qty,
        harga,
        subtotal,
        discount_percent,
      }, { transaction: t });

      // Deduct stock from StockGudangToko for the correct store
      const stokToko = await StockGudangToko.findOne({
        where: { barangId: item.barangId, storeId },
        transaction: t,
        lock: t.LOCK.UPDATE,
      });
      if (!stokToko) {
        await t.rollback();
        return res.status(400).json({ message: `Stok barang dengan ID ${item.barangId} di toko ${storeId} tidak ditemukan` });
      }
      if (parseFloat(stokToko.stok) < qty) {
        await t.rollback();
        return res.status(400).json({ message: `Stok barang di toko tidak mencukupi untuk barangId ${item.barangId}` });
      }
      stokToko.stok = parseFloat(stokToko.stok) - qty;
      await stokToko.save({ transaction: t });
    }

    await t.commit();
    
    // Log the sale creation
    LogService.logSale(
      req.user?.id,
      sale.id,
      'CREATE',
      {
        kode: sale.kode,
        total: sale.total,
        itemsCount: items.length,
        storeId: sale.storeId
      },
      req.ip || req.connection.remoteAddress
    );
    
    res.status(201).json({ message: "Transaksi penjualan berhasil", data: sale });
  } catch (err) {
    await t.rollback();
    res.status(500).json({ message: "Gagal membuat transaksi penjualan", error: err.message });
  }
};

exports.update = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const {
      tanggal,
      userId,
      storeId,
      paymentMethodId,
      catatan,
      items,
      discount_mode = 'item',
      bill_discount_percent = 0
    } = req.body;
    const id = req.params.id;

    const sale = await Sale.findByPk(id, {
      include: [{ model: SaleItem, as: "items" }],
      transaction: t,
    });
    if (!sale) {
      await t.rollback();
      return res.status(404).json({ message: "Data tidak ditemukan" });
    }

    if (!items || !Array.isArray(items) || items.length === 0) {
      await t.rollback();
      return res.status(400).json({ message: "Items tidak boleh kosong" });
    }
    if (!storeId) {
      await t.rollback();
      return res.status(400).json({ message: "storeId wajib diisi" });
    }
    if (discount_mode !== 'item' && discount_mode !== 'bill') {
      await t.rollback();
      return res.status(400).json({ message: "discount_mode harus 'item' atau 'bill'" });
    }
    if (discount_mode === 'bill' && (bill_discount_percent < 0 || bill_discount_percent > 100)) {
      await t.rollback();
      return res.status(400).json({ message: "bill_discount_percent harus antara 0-100" });
    }

    const oldData = {
      tanggal: sale.tanggal,
      userId: sale.userId,
      storeId: sale.storeId,
      paymentMethodId: sale.paymentMethodId,
      catatan: sale.catatan,
      total: sale.total,
      discount_mode: sale.discount_mode,
      bill_discount_percent: sale.bill_discount_percent,
      itemsCount: sale.items?.length || 0
    };

    // Restore stock from old sale items
    const oldStoreId = sale.storeId;
    if (sale.items && sale.items.length > 0) {
      for (const oldItem of sale.items) {
        const stokToko = await StockGudangToko.findOne({
          where: { barangId: oldItem.barangId, storeId: oldStoreId },
          transaction: t,
          lock: t.LOCK.UPDATE,
        });
        if (stokToko) {
          stokToko.stok = parseFloat(stokToko.stok) + parseFloat(oldItem.qty);
          await stokToko.save({ transaction: t });
        }
      }
    }

    // Calculate totals based on discount mode
    let total = 0;
    let itemsTotal = 0;
    let billDiscount = 0;

    if (discount_mode === 'item') {
      for (const item of items) {
        const qty = parseFloat(item.qty);
        const harga = parseFloat(item.harga);
        const discount_percent = parseFloat(item.discount_percent) || 0;
        if (discount_percent < 0 || discount_percent > 100) {
          await t.rollback();
          return res.status(400).json({ message: `discount_percent untuk item ${item.barangId} harus antara 0-100` });
        }
        const subtotal = qty * harga;
        const itemDiscount = subtotal * (discount_percent / 100);
        const itemTotal = subtotal - itemDiscount;
        itemsTotal += itemTotal;
      }
      total = itemsTotal;
    } else if (discount_mode === 'bill') {
      for (const item of items) {
        const qty = parseFloat(item.qty);
        const harga = parseFloat(item.harga);
        const subtotal = qty * harga;
        itemsTotal += subtotal;
      }
      billDiscount = itemsTotal * (parseFloat(bill_discount_percent) / 100);
      total = itemsTotal - billDiscount;
    }

    // Update Sale
    await sale.update({
      tanggal,
      userId: userId || sale.userId,
      storeId,
      total,
      paymentMethodId,
      catatan,
      discount_mode,
      bill_discount_percent: discount_mode === 'bill' ? bill_discount_percent : 0,
    }, { transaction: t });

    // Delete old sale items
    await SaleItem.destroy({ where: { saleId: id }, transaction: t });

    // Create new SaleItems and deduct stock
    for (const item of items) {
      const qty = parseFloat(item.qty);
      const harga = parseFloat(item.harga);
      const discount_percent = discount_mode === 'item' ? (parseFloat(item.discount_percent) || 0) : 0;
      const subtotal = qty * harga;
      
      await SaleItem.create({
        saleId: sale.id,
        barangId: item.barangId,
        qty,
        harga,
        subtotal,
        discount_percent,
      }, { transaction: t });

      // Deduct stock from StockGudangToko for the correct store
      const stokToko = await StockGudangToko.findOne({
        where: { barangId: item.barangId, storeId },
        transaction: t,
        lock: t.LOCK.UPDATE,
      });
      if (!stokToko) {
        await t.rollback();
        return res.status(400).json({ message: `Stok barang dengan ID ${item.barangId} di toko ${storeId} tidak ditemukan` });
      }
      if (parseFloat(stokToko.stok) < qty) {
        await t.rollback();
        return res.status(400).json({ message: `Stok barang di toko tidak mencukupi untuk barangId ${item.barangId}` });
      }
      stokToko.stok = parseFloat(stokToko.stok) - qty;
      await stokToko.save({ transaction: t });
    }

    await t.commit();

    // Reload sale with all relationships
    const updatedSale = await Sale.findByPk(id, {
      include: [
        { model: User },
        { model: PaymentMethod, as: "paymentMethod" },
        { model: SaleItem, as: "items", include: [Barang] },
      ],
    });

    // Log the sale update
    LogService.logSale(
      req.user?.id,
      sale.id,
      'UPDATE',
      {
        kode: sale.kode,
        total: sale.total,
        itemsCount: items.length,
        storeId: sale.storeId
      },
      req.ip || req.connection.remoteAddress
    );

    res.json({ message: "Transaksi penjualan berhasil diperbarui", data: updatedSale });
  } catch (err) {
    await t.rollback();
    res.status(500).json({ message: "Gagal memperbarui transaksi penjualan", error: err.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const sale = await Sale.findByPk(req.params.id);
    if (!sale) return res.status(404).json({ message: "Data tidak ditemukan" });

    await Sale.destroy({ where: { id: req.params.id } });
    res.json({ message: "Penjualan berhasil dihapus" });
  } catch (err) {
    res.status(500).json({ message: "Gagal menghapus penjualan", error: err.message });
  }
};
