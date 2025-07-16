const {
  GoodReceipt,
  GoodReceiptItem,
  PurchaseOrder,
  PurchaseOrderItem,
  Barang,
  StockGudangPusat,
  Supplier,
  sequelize,
} = require('../models');
const { Op } = require('sequelize');
const { generateCode } = require('../utils/codeGenerator');
const LogService = require('../services/logService');

exports.getAll = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', startDate, endDate, status = '' } = req.query;
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

    // Add status filter
    if (status) {
      whereClause.status = status;
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

    // Step 1: Get count (without include)
    const count = await GoodReceipt.count({ where: whereClause });

    // Step 2: Get data (with include, limit, offset)
    const { count: totalCount, rows } = await GoodReceipt.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: PurchaseOrder,
          include: [
            {
              model: Supplier,
            },
          ],
        },
        {
          model: GoodReceiptItem,
          as: 'items',
          include: [Barang],
        },
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']],
      distinct: true, // Important for accurate count with joins
      subQuery: false
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
      'GOOD_RECEIPT',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data', error: err.message });
  }
};

exports.getById = async (req, res) => {
  try {
    const data = await GoodReceipt.findByPk(req.params.id, {
      include: [
        {
          model: PurchaseOrder,
          include: [
            {
              model: Supplier,
            },
          ],
        },
        {
          model: GoodReceiptItem,
          as: 'items',
          include: [Barang],
        },
      ],
    });
    if (!data) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json(data);
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'GOOD_RECEIPT',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil detail', error: err.message });
  }
};

exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { tanggal, purchaseOrderId, catatan, items } = req.body;

    let po = null;
    let poItems = [];
    let receiptInfo = {
      isPartial: false,
      totalReceived: 0,
      totalOrdered: 0,
      remainingItems: []
    };
    
    // Validate PO if provided
    if (purchaseOrderId) {
      po = await PurchaseOrder.findByPk(purchaseOrderId, {
        include: [
          {
            model: PurchaseOrderItem,
            as: 'items',
            include: [Barang],
          },
        ],
        transaction: t,
      });
      if (!po) return res.status(404).json({ message: 'PO tidak ditemukan' });
      if (po.status !== 'dikirim' && po.status !== 'partial_received') {
        return res.status(400).json({ message: 'PO harus dalam status dikirim atau partial_received' });
      }

      poItems = po.items || [];

      // Calculate totals and check remaining quantities
      for (const item of items) {
        const poItem = poItems.find(poItem => poItem.barangId === item.barangId);
        if (poItem) {
          // Calculate total already received for this item
          const totalReceived = await GoodReceiptItem.sum('qty_diterima', {
            where: {
              barangId: item.barangId,
              goodReceiptId: {
                [Op.in]: sequelize.literal(`(
                  SELECT id FROM good_receipts WHERE purchaseOrderId = ${purchaseOrderId}
                )`)
              }
            },
            transaction: t
          }) || 0;

          const remainingQty = poItem.qty - totalReceived;
          if (item.qty_diterima > remainingQty) {
            await t.rollback();
            return res.status(400).json({ 
              message: `Quantity received (${item.qty_diterima}) exceeds remaining quantity (${remainingQty}) for item ${poItem.Barang?.nama || item.barangId}` 
            });
          }

          // Track receipt information
          receiptInfo.totalReceived += item.qty_diterima;
          receiptInfo.totalOrdered += poItem.qty;
          
          if (remainingQty > item.qty_diterima) {
            receiptInfo.isPartial = true;
            receiptInfo.remainingItems.push({
              barangId: item.barangId,
              barangNama: poItem.Barang?.nama,
              remainingQty: remainingQty - item.qty_diterima
            });
          }
        }
      }
    }

    const kode = await generateCode('good-receipt', t);
    
    const gr = await GoodReceipt.create(
      { 
        kode, 
        tanggal, 
        purchaseOrderId, 
        catatan,
        status: 'outstanding' // Default status
      },
      { transaction: t }
    );

    for (const item of items) {
      await GoodReceiptItem.create(
        {
          goodReceiptId: gr.id,
          barangId: item.barangId,
          qty_diterima: item.qty_diterima,
        },
        { transaction: t }
      );

      // Update stock in Gudang Pusat (stock_gudang_pusat)
      let pusatStock = await StockGudangPusat.findOne({
        where: { barangId: item.barangId },
        transaction: t,
        lock: t.LOCK.UPDATE,
      });
      if (!pusatStock) {
        pusatStock = await StockGudangPusat.create({
          barangId: item.barangId,
          stok: item.qty_diterima,
        }, { transaction: t });
      } else {
        pusatStock.stok = parseFloat(pusatStock.stok) + parseFloat(item.qty_diterima);
        await pusatStock.save({ transaction: t });
      }

      // Update harga_beli in barang table if PO exists
      if (po && poItems.length > 0) {
        const poItem = poItems.find(poItem => poItem.barangId === item.barangId);
        if (poItem && poItem.harga > 0) {
          // Update the barang's harga_beli with the purchase order price
          await Barang.update(
            { harga_beli: poItem.harga },
            { 
              where: { id: item.barangId },
              transaction: t 
            }
          );
        }
      }
    }

    // Update PO status based on remaining quantities
    if (po) {
      const isFullyReceived = await this.checkIfPOFullyReceived(po.id, t);
      if (isFullyReceived) {
        await po.update({ status: 'diterima' }, { transaction: t });
        // Close the good receipt if PO is fully received
        await gr.update({ status: 'closed' }, { transaction: t });
      } else {
        await po.update({ status: 'partial_received' }, { transaction: t });
      }
    }

    await t.commit();
    
    // Prepare response message based on receipt type
    let message = 'Good Receipt berhasil dibuat';
    if (po) {
      if (receiptInfo.isPartial) {
        message = `Good Receipt berhasil dibuat. Partial receipt: ${receiptInfo.totalReceived} item diterima dari ${receiptInfo.totalOrdered} item yang dipesan. Harga beli telah diperbarui.`;
      } else {
        message = 'Good Receipt berhasil dibuat. Semua item telah diterima dan harga beli telah diperbarui.';
      }
    }
    
    res.status(201).json({ 
      message, 
      data: gr,
      receiptInfo
    });
  } catch (err) {
    await t.rollback();
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'GOOD_RECEIPT',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal membuat GR', error: err.message });
  }
};

// Helper function to check if PO is fully received
exports.checkIfPOFullyReceived = async (poId, transaction) => {
  const po = await PurchaseOrder.findByPk(poId, {
    include: [{ model: PurchaseOrderItem, as: 'items' }],
    transaction
  });

  if (!po || !po.items) return false;

  for (const poItem of po.items) {
    const totalReceived = await GoodReceiptItem.sum('qty_diterima', {
      where: {
        barangId: poItem.barangId,
        goodReceiptId: {
          [Op.in]: sequelize.literal(`(
            SELECT id FROM good_receipts WHERE purchaseOrderId = ${poId}
          )`)
        }
      },
      transaction
    }) || 0;

    if (totalReceived < poItem.qty) {
      return false; // Not fully received
    }
  }

  return true; // Fully received
};

// Get remaining quantities for a PO
exports.getPORemainingQuantities = async (req, res) => {
  try {
    const { poId } = req.params;
    
    const po = await PurchaseOrder.findByPk(poId, {
      include: [
        { 
          model: PurchaseOrderItem, 
          as: 'items',
          include: [Barang]
        }
      ]
    });

    if (!po) {
      return res.status(404).json({ message: 'Purchase Order tidak ditemukan' });
    }

    const remainingQuantities = [];

    for (const poItem of po.items) {
      const totalReceived = await GoodReceiptItem.sum('qty_diterima', {
        where: {
          barangId: poItem.barangId,
          goodReceiptId: {
            [Op.in]: sequelize.literal(`(
              SELECT id FROM good_receipts WHERE purchaseOrderId = ${poId}
            )`)
          }
        }
      }) || 0;

      remainingQuantities.push({
        barangId: poItem.barangId,
        barangNama: poItem.Barang?.nama,
        barangSku: poItem.Barang?.sku,
        orderedQty: poItem.qty,
        receivedQty: totalReceived,
        remainingQty: poItem.qty - totalReceived
      });
    }

    res.json({
      poId: po.id,
      poKode: po.kode,
      poStatus: po.status,
      remainingQuantities
    });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'GOOD_RECEIPT',
      'GET_PO_REMAINING_QUANTITIES',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data remaining quantities', error: err.message });
  }
};

// Update good receipt status
exports.updateStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const { id } = req.params;

    const gr = await GoodReceipt.findByPk(id);
    if (!gr) return res.status(404).json({ message: 'Good Receipt tidak ditemukan' });

    // Validate status transition
    if (gr.status === 'closed' && status === 'outstanding') {
      return res.status(400).json({ message: 'Tidak dapat mengubah status dari closed ke outstanding' });
    }

    await gr.update({ status });
    res.json({ message: `Good Receipt status berhasil diubah ke ${status}`, data: gr });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'GOOD_RECEIPT',
      'UPDATE_STATUS',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengubah status', error: err.message });
  }
};

exports.delete = async (req, res) => {
  try {
    const gr = await GoodReceipt.findByPk(req.params.id);
    if (!gr) return res.status(404).json({ message: 'Data tidak ditemukan' });

    // Optional: Jangan izinkan hapus jika sudah digunakan (reversible stok logic if needed)

    await GoodReceipt.destroy({ where: { id: req.params.id } });
    res.json({ message: 'Good Receipt berhasil dihapus' });
  } catch (err) {
    // Log error
    LogService.logError(
      err,
      req.user?.id,
      'GOOD_RECEIPT',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal hapus', error: err.message });
  }
};
