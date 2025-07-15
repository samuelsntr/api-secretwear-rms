const { Op } = require('sequelize');
const { 
  Sale, SaleItem, PurchaseOrder, PurchaseOrderItem, StockGudangPusat, 
  StockGudangToko, Barang, Kategori, Store, Supplier, User, SaleReturn, PurchaseReturn, StockRequest, StockRequestItem, StockTransfer, StockTransferItem, Expense
} = require('../models');
const LogService = require('../services/logService');
const { convertToCSV, formatCurrency, formatDate, formatPercentage } = require('../utils/csvExport');

// Helper function to get date range
const getDateRange = (period) => {
  const now = new Date();
  const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  
  switch (period) {
    case 'today':
      return {
        start: startOfDay,
        end: new Date(startOfDay.getTime() + 24 * 60 * 60 * 1000)
      };
    case 'week':
      const startOfWeek = new Date(startOfDay);
      startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
      return {
        start: startOfWeek,
        end: new Date(startOfWeek.getTime() + 7 * 24 * 60 * 60 * 1000)
      };
    case 'month':
      return {
        start: new Date(now.getFullYear(), now.getMonth(), 1),
        end: new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59)
      };
    case 'year':
      return {
        start: new Date(now.getFullYear(), 0, 1),
        end: new Date(now.getFullYear(), 11, 31, 23, 59, 59)
      };
    default:
      return {
        start: new Date(now.getFullYear(), now.getMonth(), 1),
        end: new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59)
      };
  }
};

// Main Dashboard Summary
exports.getDashboardSummary = async (req, res) => {
  try {
    const { period = 'month' } = req.query;
    const { start, end } = getDateRange(period);

    // Sales Summary
    const salesData = await Sale.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      },
      include: [
        {
          model: SaleItem,
          as: 'items',
          include: [
            { 
              model: Barang,
              include: [{ model: Kategori }]
            }
          ]
        },
        { model: Store, as: 'store' }
      ],
      order: [['createdAt', 'ASC']]
    });

    const totalSales = salesData.length;
    const totalRevenue = salesData.reduce((sum, sale) => sum + parseFloat(sale.total || 0), 0);
    const totalItems = salesData.reduce((sum, sale) => {
      return sum + sale.items.reduce((itemSum, item) => itemSum + item.qty, 0);
    }, 0);

    // Purchase Summary
    const purchaseData = await PurchaseOrder.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      },
      include: [
        {
          model: PurchaseOrderItem,
          as: 'items',
          include: [{ model: Barang }]
        }
      ]
    });

    const totalPurchases = purchaseData.length;
    const totalPurchaseAmount = purchaseData.reduce((sum, po) => {
      return sum + po.items.reduce((itemSum, item) => itemSum + parseFloat(item.subtotal || 0), 0);
    }, 0);

    // Inventory Summary
    const stockGudangPusat = await StockGudangPusat.findAll({
      include: [{ model: Barang }]
    });

    const stockGudangToko = await StockGudangToko.findAll({
      include: [
        { model: Barang },
        { model: Store }
      ]
    });

    // Calculate total stock value including both central warehouse and stores
    const totalStockValue = stockGudangPusat.reduce((sum, stock) => {
      return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
    }, 0) + stockGudangToko.reduce((sum, stock) => {
      return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
    }, 0);

    // Count low stock items from both central warehouse and stores
    const lowStockItems = stockGudangPusat.filter(stock => stock.stok <= (stock.minimum_stock || 10)).length +
                         stockGudangToko.filter(stock => stock.stok <= 10).length;

    // Count total products (unique products across all locations)
    const allProducts = new Set();
    stockGudangPusat.forEach(stock => allProducts.add(stock.barangId));
    stockGudangToko.forEach(stock => allProducts.add(stock.barangId));
    const totalProducts = allProducts.size;

    // Returns Summary
    const salesReturns = await SaleReturn.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      }
    });

    const purchaseReturns = await PurchaseReturn.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      }
    });

    const totalSalesReturns = salesReturns.length;
    const totalPurchaseReturns = purchaseReturns.length;

    // Generate sales trend data (monthly for the last 6 months)
    const salesTrendData = [];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    for (let i = 5; i >= 0; i--) {
      const date = new Date();
      date.setMonth(date.getMonth() - i);
      const monthName = months[date.getMonth()];
      const year = date.getFullYear();
      
      // Get sales for this month
      const monthStart = new Date(year, date.getMonth(), 1);
      const monthEnd = new Date(year, date.getMonth() + 1, 0, 23, 59, 59);
      
      const monthSales = await Sale.findAll({
        where: {
          createdAt: {
            [Op.between]: [monthStart, monthEnd]
          }
        },
        include: [
          {
            model: SaleItem,
            as: 'items'
          }
        ]
      });
      
      const monthRevenue = monthSales.reduce((sum, sale) => sum + parseFloat(sale.total || 0), 0);
      const monthItems = monthSales.reduce((sum, sale) => {
        return sum + sale.items.reduce((itemSum, item) => itemSum + item.qty, 0);
      }, 0);
      
      salesTrendData.push({
        name: monthName,
        sales: monthItems,
        revenue: monthRevenue
      });
    }

    // Generate category sales data
    const categorySales = {};
    salesData.forEach(sale => {
      sale.items.forEach(item => {
        const categoryName = item.Barang?.Kategori?.nama || 'Unknown';
        if (!categorySales[categoryName]) {
          categorySales[categoryName] = { quantity: 0, revenue: 0 };
        }
        categorySales[categoryName].quantity += item.qty;
        categorySales[categoryName].revenue += parseFloat(item.subtotal || 0);
      });
    });

    const categoryData = Object.entries(categorySales).map(([name, data]) => ({
      name,
      value: Math.round((data.revenue / totalRevenue) * 100),
      revenue: data.revenue,
      quantity: data.quantity
    })).sort((a, b) => b.value - a.value);

    // Generate top products data
    const productSales = {};
    salesData.forEach(sale => {
      sale.items.forEach(item => {
        const productName = item.Barang?.nama || 'Unknown';
        if (!productSales[productName]) {
          productSales[productName] = { quantity: 0, revenue: 0 };
        }
        productSales[productName].quantity += item.qty;
        productSales[productName].revenue += parseFloat(item.subtotal || 0);
      });
    });

    const topProductsData = Object.entries(productSales)
      .map(([name, data]) => ({ name, ...data }))
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 5);

    // Calculate growth percentages by comparing with previous period
    const getPreviousPeriodRange = (currentStart, currentEnd) => {
      const duration = currentEnd.getTime() - currentStart.getTime();
      const previousEnd = new Date(currentStart.getTime() - 1);
      const previousStart = new Date(previousEnd.getTime() - duration);
      return { start: previousStart, end: previousEnd };
    };

    const { start: prevStart, end: prevEnd } = getPreviousPeriodRange(start, end);

    // Get previous period data for comparison
    const previousSalesData = await Sale.findAll({
      where: {
        createdAt: {
          [Op.between]: [prevStart, prevEnd]
        }
      },
      include: [
        {
          model: SaleItem,
          as: 'items'
        }
      ]
    });

    const previousPurchaseData = await PurchaseOrder.findAll({
      where: {
        createdAt: {
          [Op.between]: [prevStart, prevEnd]
        }
      },
      include: [
        {
          model: PurchaseOrderItem,
          as: 'items'
        }
      ]
    });

    const previousSalesReturns = await SaleReturn.findAll({
      where: {
        createdAt: {
          [Op.between]: [prevStart, prevEnd]
        }
      }
    });

    const previousPurchaseReturns = await PurchaseReturn.findAll({
      where: {
        createdAt: {
          [Op.between]: [prevStart, prevEnd]
        }
      }
    });

    // Calculate previous period totals
    const previousRevenue = previousSalesData.reduce((sum, sale) => sum + parseFloat(sale.total || 0), 0);
    const previousPurchaseAmount = previousPurchaseData.reduce((sum, po) => {
      return sum + po.items.reduce((itemSum, item) => itemSum + parseFloat(item.subtotal || 0), 0);
    }, 0);
    const previousReturns = previousSalesReturns.length + previousPurchaseReturns.length;

    // Calculate growth percentages
    const revenueGrowth = previousRevenue > 0 
      ? ((totalRevenue - previousRevenue) / previousRevenue) * 100 
      : totalRevenue > 0 ? 100 : 0;
    
    const purchaseGrowth = previousPurchaseAmount > 0 
      ? ((totalPurchaseAmount - previousPurchaseAmount) / previousPurchaseAmount) * 100 
      : totalPurchaseAmount > 0 ? 100 : 0;
    
    const returnsGrowth = previousReturns > 0 
      ? (((totalSalesReturns + totalPurchaseReturns) - previousReturns) / previousReturns) * 100 
      : (totalSalesReturns + totalPurchaseReturns) > 0 ? 100 : 0;

    res.json({
      success: true,
      data: {
        period,
        dateRange: { start, end },
        sales: {
          totalSales,
          totalRevenue,
          totalItems,
          averageOrderValue: totalSales > 0 ? totalRevenue / totalSales : 0,
          growth: revenueGrowth
        },
        purchase: {
          totalPurchases,
          totalPurchaseAmount,
          averagePurchaseValue: totalPurchases > 0 ? totalPurchaseAmount / totalPurchases : 0,
          growth: purchaseGrowth
        },
        inventory: {
          totalStockValue,
          lowStockItems,
          totalProducts
        },
        returns: {
          salesReturns: totalSalesReturns,
          purchaseReturns: totalPurchaseReturns,
          growth: returnsGrowth
        },
        charts: {
          salesTrend: salesTrendData,
          categoryDistribution: categoryData,
          topProducts: topProductsData
        }
      }
    });
  } catch (error) {
    console.error('Error getting dashboard summary:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Sales Report
exports.getSalesReport = async (req, res) => {
  try {
    const { period = 'month', storeId, categoryId } = req.query;
    
    // Log report access
    LogService.logReportAccess(
      req.user?.id,
      'SALES',
      { period, storeId, categoryId },
      req.ip || req.connection.remoteAddress
    );
    const { start, end } = getDateRange(period);

    let whereClause = {
      createdAt: {
        [Op.between]: [start, end]
      }
    };

    if (storeId) {
      whereClause.storeId = storeId;
    }

    const salesData = await Sale.findAll({
      where: whereClause,
      include: [
        {
          model: SaleItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }],
              where: categoryId ? { kategoriId: categoryId } : {}
            }
          ]
        },
        { model: Store, as: 'store' },
        { model: User }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Calculate metrics
    const totalSales = salesData.length;
    const totalRevenue = salesData.reduce((sum, sale) => sum + parseFloat(sale.total || 0), 0);
    const totalItems = salesData.reduce((sum, sale) => {
      return sum + sale.items.reduce((itemSum, item) => itemSum + item.qty, 0);
    }, 0);

    // Top selling products
    const productSales = {};
    salesData.forEach(sale => {
      sale.items.forEach(item => {
        const productName = item.Barang?.nama || 'Unknown';
        if (!productSales[productName]) {
          productSales[productName] = { quantity: 0, revenue: 0 };
        }
        productSales[productName].quantity += item.qty;
        productSales[productName].revenue += parseFloat(item.subtotal || 0);
      });
    });

    const topProducts = Object.entries(productSales)
      .map(([name, data]) => ({ name, ...data }))
      .sort((a, b) => b.quantity - a.quantity)
      .slice(0, 10);

    // Sales by category
    const categorySales = {};
    salesData.forEach(sale => {
      sale.items.forEach(item => {
        const categoryName = item.Barang?.Kategori?.nama || 'Unknown';
        if (!categorySales[categoryName]) {
          categorySales[categoryName] = { quantity: 0, revenue: 0 };
        }
        categorySales[categoryName].quantity += item.qty;
        categorySales[categoryName].revenue += parseFloat(item.subtotal || 0);
      });
    });

    res.json({
      success: true,
      data: {
        period,
        dateRange: { start, end },
        summary: {
          totalSales,
          totalRevenue,
          totalItems,
          averageOrderValue: totalSales > 0 ? totalRevenue / totalSales : 0
        },
        topProducts,
        categorySales: Object.entries(categorySales).map(([name, data]) => ({ name, ...data })),
        sales: salesData
      }
    });
  } catch (error) {
    console.error('Error getting sales report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Inventory Report
exports.getInventoryReport = async (req, res) => {
  try {
    const { storeId } = req.query;
    
    // Log report access
    LogService.logReportAccess(
      req.user?.id,
      'INVENTORY',
      { storeId },
      req.ip || req.connection.remoteAddress
    );

    // Get all stock data
    const stockGudangPusat = await StockGudangPusat.findAll({
      include: [
        { model: Barang, include: [{ model: Kategori }] }
      ]
    });

    let stockGudangToko = [];
    if (!storeId || storeId !== 'central') {
      let whereClause = {};
      if (storeId && storeId !== 'central') {
        whereClause.storeId = storeId;
      }
      
      stockGudangToko = await StockGudangToko.findAll({
        where: whereClause,
        include: [
          { model: Barang, include: [{ model: Kategori }] },
          { model: Store }
        ]
      });
    }

    // Determine which data to use based on storeId
    let inventoryData = [];
    let totalStockValue = 0;
    let lowStockItems = [];
    let outOfStockItems = [];

    if (storeId === 'central') {
      // Show only central warehouse data
      inventoryData = stockGudangPusat;
      totalStockValue = stockGudangPusat.reduce((sum, stock) => {
        return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
      }, 0);
      lowStockItems = stockGudangPusat.filter(stock => stock.stok <= (stock.minimum_stock || 10));
      outOfStockItems = stockGudangPusat.filter(stock => stock.stok <= 0);
    } else {
      // Show store data (and central warehouse if no storeId specified)
      if (storeId) {
        // Specific store
        inventoryData = stockGudangToko;
        totalStockValue = stockGudangToko.reduce((sum, stock) => {
          return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
        }, 0);
        lowStockItems = stockGudangToko.filter(stock => stock.stok <= 10);
        outOfStockItems = stockGudangToko.filter(stock => stock.stok <= 0);
      } else {
        // All stores + central warehouse
        inventoryData = [...stockGudangPusat, ...stockGudangToko];
        totalStockValue = inventoryData.reduce((sum, stock) => {
          return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
        }, 0);
        lowStockItems = inventoryData.filter(stock => stock.stok <= 10);
        outOfStockItems = inventoryData.filter(stock => stock.stok <= 0);
      }
    }

    // Stock by category
    const stockByCategory = {};
    inventoryData.forEach(stock => {
      const categoryName = stock.Barang?.Kategori?.nama || 'Unknown';
      if (!stockByCategory[categoryName]) {
        stockByCategory[categoryName] = { items: 0, totalValue: 0 };
      }
      stockByCategory[categoryName].items += 1;
      stockByCategory[categoryName].totalValue += parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0);
    });

    // Store-wise inventory (only for store data)
    const storeInventory = {};
    if (storeId !== 'central') {
      stockGudangToko.forEach(stock => {
        const storeName = stock.Store?.nama || 'Unknown';
        if (!storeInventory[storeName]) {
          storeInventory[storeName] = { items: 0, totalValue: 0 };
        }
        storeInventory[storeName].items += 1;
        storeInventory[storeName].totalValue += parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0);
      });
    }

    // Debug logging
    console.log('Inventory Report Debug:', {
      storeId,
      inventoryDataLength: inventoryData.length,
      totalStockValue,
      lowStockItemsCount: lowStockItems.length,
      outOfStockItemsCount: outOfStockItems.length,
      sampleItem: inventoryData[0] ? {
        id: inventoryData[0].id,
        name: inventoryData[0].Barang?.nama,
        stok: inventoryData[0].stok,
        harga_beli: inventoryData[0].Barang?.harga_beli,
        isCentral: inventoryData[0].hasOwnProperty('minimum_stock')
      } : null
    });

    res.json({
      success: true,
      data: {
        summary: {
          totalProducts: inventoryData.length,
          totalStockValue,
          lowStockItems: lowStockItems.length,
          outOfStockItems: outOfStockItems.length
        },
        categoryStock: Object.entries(stockByCategory).map(([name, data]) => ({ 
          name, 
          productCount: data.items,
          totalValue: data.totalValue 
        })),
        storeInventory: Object.entries(storeInventory).map(([name, data]) => ({ name, ...data })),
        lowStockItems: lowStockItems.map((item, index) => {
          const isCentral = item.hasOwnProperty('minimum_stock');
          return {
            id: `${isCentral ? 'central' : 'store'}_${item.id}_${index}`,
            originalId: item.id,
            name: item.Barang?.nama,
            category: item.Barang?.Kategori?.nama,
            store: isCentral ? 'Central Warehouse' : (item.Store?.nama || 'Central Warehouse'),
            currentStock: item.stok,
            minStock: isCentral ? (item.minimum_stock || 10) : 10,
            stockValue: parseFloat(item.stok || 0) * parseFloat(item.Barang?.harga_beli || 0)
          };
        }),
        outOfStockItems: outOfStockItems.map((item, index) => {
          const isCentral = item.hasOwnProperty('minimum_stock');
          return {
            id: `${isCentral ? 'central' : 'store'}_${item.id}_${index}`,
            originalId: item.id,
            name: item.Barang?.nama,
            category: item.Barang?.Kategori?.nama,
            store: isCentral ? 'Central Warehouse' : (item.Store?.nama || 'Central Warehouse'),
            currentStock: item.stok,
            minStock: isCentral ? (item.minimum_stock || 10) : 10,
            stockValue: parseFloat(item.stok || 0) * parseFloat(item.Barang?.harga_beli || 0)
          };
        }),
        inventory: inventoryData.map((item, index) => {
          const isCentral = item.hasOwnProperty('minimum_stock');
          return {
            id: `${isCentral ? 'central' : 'store'}_${item.id}_${index}`,
            originalId: item.id,
            name: item.Barang?.nama,
            code: item.Barang?.sku,
            category: item.Barang?.Kategori?.nama,
            store: isCentral ? 'Central Warehouse' : (item.Store?.nama || 'Central Warehouse'),
            currentStock: item.stok,
            minStock: isCentral ? (item.minimum_stock || 10) : 10,
            stockValue: parseFloat(item.stok || 0) * parseFloat(item.Barang?.harga_beli || 0)
          };
        })
      }
    });
  } catch (error) {
    console.error('Error getting inventory report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Purchase Report
exports.getPurchaseReport = async (req, res) => {
  try {
    const { period = 'month', supplierId } = req.query;
    const { start, end } = getDateRange(period);

    let whereClause = {
      createdAt: {
        [Op.between]: [start, end]
      }
    };

    if (supplierId) {
      whereClause.supplierId = supplierId;
    }

    const purchaseData = await PurchaseOrder.findAll({
      where: whereClause,
      include: [
        {
          model: PurchaseOrderItem,
          as: 'items',
          include: [{ model: Barang }]
        },
        { model: Supplier }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Calculate metrics
    const totalPurchases = purchaseData.length;
    const totalAmount = purchaseData.reduce((sum, po) => {
      return sum + po.items.reduce((itemSum, item) => itemSum + parseFloat(item.subtotal || 0), 0);
    }, 0);
    const totalItems = purchaseData.reduce((sum, po) => {
      return sum + po.items.reduce((itemSum, item) => itemSum + item.qty, 0);
    }, 0);

    // Purchases by supplier
    const supplierPurchases = {};
    purchaseData.forEach(po => {
      const supplierName = po.Supplier?.nama || 'Unknown';
      if (!supplierPurchases[supplierName]) {
        supplierPurchases[supplierName] = { orders: 0, totalAmount: 0, totalItems: 0, lastOrderDate: po.createdAt };
      }
      supplierPurchases[supplierName].orders += 1;
      supplierPurchases[supplierName].totalAmount += po.items.reduce((sum, item) => sum + parseFloat(item.subtotal || 0), 0);
      supplierPurchases[supplierName].totalItems += po.items.reduce((sum, item) => sum + item.qty, 0);
      if (po.createdAt > supplierPurchases[supplierName].lastOrderDate) {
        supplierPurchases[supplierName].lastOrderDate = po.createdAt;
      }
    });

    // Purchases by category
    const categoryPurchases = {};
    purchaseData.forEach(po => {
      po.items.forEach(item => {
        const categoryName = item.Barang?.Kategori?.nama || 'Unknown';
        if (!categoryPurchases[categoryName]) {
          categoryPurchases[categoryName] = { quantity: 0, totalAmount: 0 };
        }
        categoryPurchases[categoryName].quantity += item.qty;
        categoryPurchases[categoryName].totalAmount += parseFloat(item.subtotal || 0);
      });
    });

    // Top purchased products
    const productPurchases = {};
    purchaseData.forEach(po => {
      po.items.forEach(item => {
        const productName = item.Barang?.nama || 'Unknown';
        if (!productPurchases[productName]) {
          productPurchases[productName] = { quantity: 0, amount: 0 };
        }
        productPurchases[productName].quantity += item.qty;
        productPurchases[productName].amount += parseFloat(item.subtotal || 0);
      });
    });

    const topPurchasedProducts = Object.entries(productPurchases)
      .map(([name, data]) => ({ name, ...data }))
      .sort((a, b) => b.quantity - a.quantity)
      .slice(0, 10);

    // Prepare supplier performance data
    const supplierPerformance = Object.entries(supplierPurchases).map(([name, data]) => ({
      name,
      orderCount: data.orders,
      totalAmount: data.totalAmount,
      totalItems: data.totalItems,
      averageOrderValue: data.orders > 0 ? data.totalAmount / data.orders : 0,
      lastOrderDate: data.lastOrderDate
    }));

    // Calculate totals for each purchase order
    const purchasesWithTotals = purchaseData.map(po => {
      const totalAmount = po.items.reduce((sum, item) => sum + parseFloat(item.subtotal || 0), 0);
      const totalItems = po.items.reduce((sum, item) => sum + item.qty, 0);
      
      // Debug logging
      console.log('Purchase Order Debug:', {
        id: po.id,
        kode: po.kode,
        itemsCount: po.items.length,
        totalAmount,
        totalItems,
        sampleItem: po.items[0] ? {
          qty: po.items[0].qty,
          subtotal: po.items[0].subtotal
        } : null
      });
      
      return {
        ...po.toJSON(),
        total_amount: totalAmount,
        total_items: totalItems
      };
    });

    res.json({
      success: true,
      data: {
        period,
        dateRange: { start, end },
        summary: {
          totalPurchases,
          totalAmount,
          totalItems,
          averageOrderValue: totalPurchases > 0 ? totalAmount / totalPurchases : 0
        },
        topSuppliers: Object.entries(supplierPurchases)
          .map(([name, data]) => ({ 
            name, 
            orderCount: data.orders, 
            totalAmount: data.totalAmount 
          }))
          .sort((a, b) => b.totalAmount - a.totalAmount)
          .slice(0, 10),
        categoryPurchases: Object.entries(categoryPurchases).map(([name, data]) => ({ 
          name, 
          quantity: data.quantity, 
          totalAmount: data.totalAmount 
        })),
        supplierPerformance,
        topPurchasedProducts,
        purchases: purchasesWithTotals
      }
    });
  } catch (error) {
    console.error('Error getting purchase report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Financial Summary
exports.getFinancialSummary = async (req, res) => {
  try {
    const { period = 'month' } = req.query;
    const { start, end } = getDateRange(period);

    // Sales revenue
    const salesData = await Sale.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      }
    });

    const totalRevenue = salesData.reduce((sum, sale) => sum + parseFloat(sale.total || 0), 0);

    // Purchase costs
    const purchaseData = await PurchaseOrder.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      },
      include: [
        {
          model: PurchaseOrderItem,
          as: 'items'
        }
      ]
    });

    const totalCosts = purchaseData.reduce((sum, po) => {
      return sum + po.items.reduce((itemSum, item) => itemSum + parseFloat(item.subtotal || 0), 0);
    }, 0);

    // Returns
    const salesReturns = await SaleReturn.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      }
    });

    const purchaseReturns = await PurchaseReturn.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      }
    });

    const salesReturnsAmount = salesReturns.reduce((sum, ret) => sum + parseFloat(ret.total_amount || 0), 0);
    const purchaseReturnsAmount = purchaseReturns.reduce((sum, ret) => sum + parseFloat(ret.total_amount || 0), 0);

    // Additional Expenses
    const additionalExpenses = await Expense.findAll({
      where: {
        date: {
          [Op.between]: [start, end]
        }
      }
    });
    const totalAdditionalExpenses = additionalExpenses.reduce((sum, exp) => sum + parseFloat(exp.amount || 0), 0);

    // Calculate net profit (with additional expenses)
    const netRevenue = totalRevenue - salesReturnsAmount;
    const netCosts = totalCosts - purchaseReturnsAmount;
    const operatingExpenses = totalAdditionalExpenses;
    const totalExpenses = netCosts + operatingExpenses;
    const netProfit = netRevenue - totalExpenses;
    const profitMargin = netRevenue > 0 ? (netProfit / netRevenue) * 100 : 0;

    // Inventory value (central warehouse + stores)
    const stockGudangPusat = await StockGudangPusat.findAll({
      include: [{ model: Barang }]
    });

    const stockGudangToko = await StockGudangToko.findAll({
      include: [
        { model: Barang },
        { model: Store }
      ]
    });

    const inventoryValue = stockGudangPusat.reduce((sum, stock) => {
      return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
    }, 0) + stockGudangToko.reduce((sum, stock) => {
      return sum + (parseFloat(stock.stok || 0) * parseFloat(stock.Barang?.harga_beli || 0));
    }, 0);

    res.json({
      success: true,
      data: {
        period,
        dateRange: { start, end },
        summary: {
          totalRevenue: netRevenue,
          totalExpenses: totalExpenses,
          netProfit: netProfit,
          profitMargin: profitMargin
        },
        revenue: {
          salesRevenue: totalRevenue,
          otherRevenue: 0,
          totalRevenue: netRevenue,
          salesReturns: salesReturnsAmount
        },
        expenses: {
          costOfGoodsSold: netCosts,
          operatingExpenses: operatingExpenses,
          otherExpenses: 0,
          totalExpenses: totalExpenses,
          expenseDetails: additionalExpenses,
        },
        ratios: { 
          profitMargin: profitMargin,
          grossMargin: netRevenue > 0 ? ((netRevenue - netCosts) / netRevenue) * 100 : 0,
          expenseRatio: netRevenue > 0 ? (totalExpenses / netRevenue) * 100 : 0,
          revenueGrowth: 0 // Will be calculated when needed
        },
        monthlyTrends: [
          {
            month: new Date().toLocaleDateString('en-US', { month: 'long', year: 'numeric' }),
            revenue: netRevenue,
            profit: netProfit,
            transactions: salesData.length
          }
        ],
        categoryPerformance: [
          {
            name: 'All Categories',
            revenue: netRevenue,
            cost: totalExpenses,
            profit: netProfit,
            margin: profitMargin
          }
        ]
      }
    });
  } catch (error) {
    console.error('Error getting financial summary:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Product Performance Report
exports.getProductPerformance = async (req, res) => {
  try {
    const { period = 'month', categoryId } = req.query;
    const { start, end } = getDateRange(period);

    // Get sales data
    const salesData = await Sale.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        }
      },
      include: [
        {
          model: SaleItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }],
              where: categoryId ? { kategoriId: categoryId } : {}
            }
          ]
        }
      ]
    });

    // Calculate product performance
    const productPerformance = {};
    salesData.forEach(sale => {
      sale.items.forEach(item => {
        const productId = item.barangId;
        const productName = item.Barang?.nama || 'Unknown';
        const categoryName = item.Barang?.Kategori?.nama || 'Unknown';
        
        if (!productPerformance[productId]) {
          productPerformance[productId] = {
            id: productId,
            name: productName,
            category: categoryName,
            sku: item.Barang?.sku || 'N/A',
            totalSold: 0,
            totalRevenue: 0,
            averagePrice: 0
          };
        }
        
        productPerformance[productId].totalSold += item.qty;
        productPerformance[productId].totalRevenue += parseFloat(item.subtotal || 0);
      });
    });

    // Calculate average price and sort by revenue
    Object.values(productPerformance).forEach(product => {
      product.averagePrice = product.totalSold > 0 ? product.totalRevenue / product.totalSold : 0;
    });

    const topProducts = Object.values(productPerformance)
      .sort((a, b) => b.totalRevenue - a.totalRevenue)
      .slice(0, 20);

    const topSellingProducts = Object.values(productPerformance)
      .sort((a, b) => b.totalSold - a.totalSold)
      .slice(0, 20);

    // Calculate performance metrics
    const totalProducts = Object.keys(productPerformance).length;
    const totalRevenue = Object.values(productPerformance).reduce((sum, p) => sum + p.totalRevenue, 0);
    const totalSold = Object.values(productPerformance).reduce((sum, p) => sum + p.totalSold, 0);
    
    // Calculate performance scores and categorize products
    const productsWithScores = Object.values(productPerformance).map(product => {
      const performanceScore = totalRevenue > 0 ? (product.totalRevenue / totalRevenue) * 100 : 0;
      return {
        ...product,
        performanceScore,
        revenue: product.totalRevenue,
        quantitySold: product.totalSold,
        sku: product.sku || 'N/A' // Use actual SKU from database
      };
    });

    const topPerformers = productsWithScores.filter(p => p.performanceScore > 10).length;
    const lowPerformers = productsWithScores.filter(p => p.performanceScore < 5).length;
    const averagePerformance = productsWithScores.length > 0 
      ? productsWithScores.reduce((sum, p) => sum + p.performanceScore, 0) / productsWithScores.length 
      : 0;

    // Group by category
    const categoryPerformance = {};
    productsWithScores.forEach(product => {
      if (!categoryPerformance[product.category]) {
        categoryPerformance[product.category] = {
          name: product.category,
          productCount: 0,
          revenue: 0,
          quantitySold: 0,
          performanceScore: 0
        };
      }
      categoryPerformance[product.category].productCount++;
      categoryPerformance[product.category].revenue += product.revenue;
      categoryPerformance[product.category].quantitySold += product.quantitySold;
    });

    // Calculate category performance scores
    Object.values(categoryPerformance).forEach(category => {
      category.performanceScore = totalRevenue > 0 ? (category.revenue / totalRevenue) * 100 : 0;
    });

    // Generate insights
    const insights = [];
    if (topPerformers > 0) {
      insights.push({
        type: "positive",
        title: "High Performing Products",
        description: `${topPerformers} products are performing exceptionally well`
      });
    }
    if (lowPerformers > 0) {
      insights.push({
        type: "negative",
        title: "Low Performing Products",
        description: `${lowPerformers} products need attention and optimization`
      });
    }

    res.json({
      success: true,
      data: {
        period,
        dateRange: { start, end },
        summary: {
          totalProducts,
          topPerformers,
          lowPerformers,
          averagePerformance
        },
        topProducts: productsWithScores.slice(0, 10),
        products: productsWithScores,
        categoryPerformance: Object.values(categoryPerformance),
        insights
      }
    });
  } catch (error) {
    console.error('Error getting product performance:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Moving Stock Report
exports.getMovingStockReport = async (req, res) => {
  try {
    const { period = 'month', storeId, status, startDate, endDate } = req.query;
    
    // Log report access
    LogService.logReportAccess(
      req.user?.id,
      'MOVING_STOCK',
      { period, storeId, status, startDate, endDate },
      req.ip || req.connection.remoteAddress
    );
    
    // Use custom date range if provided, otherwise use period
    let start, end;
    if (startDate && endDate) {
      start = new Date(startDate);
      end = new Date(endDate);
      end.setHours(23, 59, 59, 999); // End of day
    } else {
      const dateRange = getDateRange(period);
      start = dateRange.start;
      end = dateRange.end;
    }

    // Get stock requests
    const stockRequests = await StockRequest.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        },
        ...(storeId && { toStoreId: storeId }),
        ...(status && { status })
      },
      include: [
        {
          model: StockRequestItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }]
            }
          ]
        },
        { model: Store, as: 'toStore' }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Get stock transfers
    const stockTransfers = await StockTransfer.findAll({
      where: {
        createdAt: {
          [Op.between]: [start, end]
        },
        ...(storeId && { storeId }),
        ...(status && { status })
      },
      include: [
        {
          model: StockTransferItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }]
            }
          ]
        },
        {
          model: StockRequest,
          include: [{ model: Store, as: 'toStore' }]
        },
        { model: Store, as: 'toStore' }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Calculate summary metrics
    const totalRequests = stockRequests.length;
    const totalTransfers = stockTransfers.length;
    
    const pendingRequests = stockRequests.filter(req => req.status === 'pending').length;
    const approvedRequests = stockRequests.filter(req => req.status === 'approved').length;
    const fulfilledRequests = stockRequests.filter(req => req.status === 'fulfilled').length;
    const rejectedRequests = stockRequests.filter(req => req.status === 'rejected').length;
    
    const pendingTransfers = stockTransfers.filter(trans => trans.status === 'pending').length;
    const completedTransfers = stockTransfers.filter(trans => trans.status === 'completed').length;

    // Calculate total quantities moved
    const totalRequestedQuantity = stockRequests.reduce((sum, req) => {
      return sum + req.items.reduce((itemSum, item) => itemSum + item.qty, 0);
    }, 0);

    const totalTransferredQuantity = stockTransfers.reduce((sum, trans) => {
      return sum + trans.items.reduce((itemSum, item) => itemSum + item.qty, 0);
    }, 0);

    // Group by store
    const storeMovements = {};
    stockRequests.forEach(req => {
      const storeName = req.toStore?.nama || 'Unknown Store';
      if (!storeMovements[storeName]) {
        storeMovements[storeName] = {
          name: storeName,
          requests: 0,
          transfers: 0,
          requestedQuantity: 0,
          transferredQuantity: 0
        };
      }
      storeMovements[storeName].requests++;
      storeMovements[storeName].requestedQuantity += req.items.reduce((sum, item) => sum + item.qty, 0);
    });

    stockTransfers.forEach(trans => {
      const storeName = trans.toStore?.nama || 'Unknown Store';
      if (!storeMovements[storeName]) {
        storeMovements[storeName] = {
          name: storeName,
          requests: 0,
          transfers: 0,
          requestedQuantity: 0,
          transferredQuantity: 0
        };
      }
      storeMovements[storeName].transfers++;
      storeMovements[storeName].transferredQuantity += trans.items.reduce((sum, item) => sum + item.qty, 0);
    });

    // Group by category
    const categoryMovements = {};
    stockRequests.forEach(req => {
      req.items.forEach(item => {
        const categoryName = item.Barang?.Kategori?.nama || 'Unknown';
        if (!categoryMovements[categoryName]) {
          categoryMovements[categoryName] = {
            name: categoryName,
            requestedQuantity: 0,
            transferredQuantity: 0,
            requestCount: 0,
            transferCount: 0
          };
        }
        categoryMovements[categoryName].requestedQuantity += item.qty;
        categoryMovements[categoryName].requestCount++;
      });
    });

    stockTransfers.forEach(trans => {
      trans.items.forEach(item => {
        const categoryName = item.Barang?.Kategori?.nama || 'Unknown';
        if (!categoryMovements[categoryName]) {
          categoryMovements[categoryName] = {
            name: categoryName,
            requestedQuantity: 0,
            transferredQuantity: 0,
            requestCount: 0,
            transferCount: 0
          };
        }
        categoryMovements[categoryName].transferredQuantity += item.qty;
        categoryMovements[categoryName].transferCount++;
      });
    });

    // Top requested products
    const productRequests = {};
    stockRequests.forEach(req => {
      req.items.forEach(item => {
        const productName = item.Barang?.nama || 'Unknown';
        if (!productRequests[productName]) {
          productRequests[productName] = {
            name: productName,
            category: item.Barang?.Kategori?.nama || 'Unknown',
            sku: item.Barang?.sku || 'N/A',
            requestedQuantity: 0,
            requestCount: 0
          };
        }
        productRequests[productName].requestedQuantity += item.qty;
        productRequests[productName].requestCount++;
      });
    });

    const topRequestedProducts = Object.values(productRequests)
      .sort((a, b) => b.requestedQuantity - a.requestedQuantity)
      .slice(0, 10);

    // Top transferred products
    const productTransfers = {};
    stockTransfers.forEach(trans => {
      trans.items.forEach(item => {
        const productName = item.Barang?.nama || 'Unknown';
        if (!productTransfers[productName]) {
          productTransfers[productName] = {
            name: productName,
            category: item.Barang?.Kategori?.nama || 'Unknown',
            sku: item.Barang?.sku || 'N/A',
            transferredQuantity: 0,
            transferCount: 0
          };
        }
        productTransfers[productName].transferredQuantity += item.qty;
        productTransfers[productName].transferCount++;
      });
    });

    const topTransferredProducts = Object.values(productTransfers)
      .sort((a, b) => b.transferredQuantity - a.transferredQuantity)
      .slice(0, 10);

    // Monthly trends
    const monthlyTrends = [];
    const months = {};
    
    stockRequests.forEach(req => {
      const month = req.createdAt.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
      if (!months[month]) {
        months[month] = { month, requests: 0, transfers: 0, requestedQty: 0, transferredQty: 0 };
      }
      months[month].requests++;
      months[month].requestedQty += req.items.reduce((sum, item) => sum + item.qty, 0);
    });

    stockTransfers.forEach(trans => {
      const month = trans.createdAt.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
      if (!months[month]) {
        months[month] = { month, requests: 0, transfers: 0, requestedQty: 0, transferredQty: 0 };
      }
      months[month].transfers++;
      months[month].transferredQty += trans.items.reduce((sum, item) => sum + item.qty, 0);
    });

    Object.values(months).forEach(monthData => {
      monthlyTrends.push(monthData);
    });

    // Generate insights
    const insights = [];
    
    if (pendingRequests > 0) {
      insights.push({
        type: "warning",
        title: "Pending Requests",
        description: `${pendingRequests} stock requests are still pending approval`
      });
    }
    
    if (pendingTransfers > 0) {
      insights.push({
        type: "warning",
        title: "Pending Transfers",
        description: `${pendingTransfers} stock transfers are pending completion`
      });
    }
    
    if (totalRequestedQuantity > totalTransferredQuantity) {
      insights.push({
        type: "info",
        title: "Request vs Transfer Gap",
        description: `More items requested (${totalRequestedQuantity}) than transferred (${totalTransferredQuantity})`
      });
    }
    
    if (Object.keys(storeMovements).length > 1) {
      const topStore = Object.values(storeMovements).sort((a, b) => b.requests - a.requests)[0];
      insights.push({
        type: "positive",
        title: "Most Active Store",
        description: `${topStore.name} has the highest stock movement activity`
      });
    }

    res.json({
      success: true,
      data: {
        period,
        dateRange: { start, end },
        summary: {
          totalRequests,
          totalTransfers,
          pendingRequests,
          approvedRequests,
          fulfilledRequests,
          rejectedRequests,
          pendingTransfers,
          completedTransfers,
          totalRequestedQuantity,
          totalTransferredQuantity
        },
        storeMovements: Object.values(storeMovements),
        categoryMovements: Object.values(categoryMovements),
        topRequestedProducts,
        topTransferredProducts,
        monthlyTrends,
        insights,
        requests: stockRequests.map(req => ({
          id: req.id,
          kode: req.kode,
          status: req.status,
          fromWarehouse: req.fromWarehouse,
          toStore: req.toStore?.nama || 'Unknown',
          totalItems: req.items.reduce((sum, item) => sum + item.qty, 0),
          createdAt: req.createdAt,
          items: req.items.map(item => ({
            name: item.Barang?.nama,
            sku: item.Barang?.sku,
            category: item.Barang?.Kategori?.nama,
            qty: item.qty
          }))
        })),
        transfers: stockTransfers.map(trans => ({
          id: trans.id,
          kode: trans.kode,
          status: trans.status,
          requestKode: trans.StockRequest?.kode,
          toStore: trans.toStore?.nama || 'Unknown',
          totalItems: trans.items.reduce((sum, item) => sum + item.qty, 0),
          createdAt: trans.createdAt,
          items: trans.items.map(item => ({
            name: item.Barang?.nama,
            sku: item.Barang?.sku,
            category: item.Barang?.Kategori?.nama,
            qty: item.qty
          }))
        }))
      }
    });
  } catch (error) {
    console.error('Error getting moving stock report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Export functions for all reports
exports.exportSalesReport = async (req, res) => {
  try {
    const { period = 'month', storeId, categoryId } = req.query;
    const { start, end } = getDateRange(period);

    let whereClause = {
      createdAt: {
        [Op.between]: [start, end]
      }
    };

    if (storeId) {
      whereClause.storeId = storeId;
    }

    const salesData = await Sale.findAll({
      where: whereClause,
      include: [
        {
          model: SaleItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }],
              where: categoryId ? { kategoriId: categoryId } : {}
            }
          ]
        },
        { model: Store, as: 'store' },
        { model: User }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Prepare data for CSV
    const csvData = salesData.map(sale => ({
      'Invoice Number': sale.kode,
      'Date': formatDate(sale.createdAt),
      'Store': sale.store?.nama || 'Central Warehouse',
      'Customer': sale.customer_name || 'Walk-in Customer',
      'Salesperson': sale.User?.username || 'System',
      'Total Items': sale.items.reduce((sum, item) => sum + item.qty, 0),
      'Total': formatCurrency(sale.total || 0),
      'Payment Method': sale.paymentMethod?.nama || 'Cash',
      'Status': sale.status || 'Completed',
      'Notes': sale.catatan || ''
    }));

    const headers = [
      { key: 'Invoice Number', label: 'Invoice Number' },
      { key: 'Date', label: 'Date' },
      { key: 'Store', label: 'Store' },
      { key: 'Customer', label: 'Customer' },
      { key: 'Salesperson', label: 'Salesperson' },
      { key: 'Total Items', label: 'Total Items' },
      { key: 'Total', label: 'Total' },
      { key: 'Payment Method', label: 'Payment Method' },
      { key: 'Status', label: 'Status' },
      { key: 'Notes', label: 'Notes' }
    ];

    const csv = convertToCSV(csvData, headers);
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=sales-report-${period}-${new Date().toISOString().split('T')[0]}.csv`);
    res.send(csv);
  } catch (error) {
    console.error('Error exporting sales report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

exports.exportPurchaseReport = async (req, res) => {
  try {
    const { period = 'month', supplierId, categoryId } = req.query;
    const { start, end } = getDateRange(period);

    let whereClause = {
      createdAt: {
        [Op.between]: [start, end]
      }
    };

    if (supplierId) {
      whereClause.supplierId = supplierId;
    }

    const purchaseData = await PurchaseOrder.findAll({
      where: whereClause,
      include: [
        {
          model: PurchaseOrderItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }],
              where: categoryId ? { kategoriId: categoryId } : {}
            }
          ]
        },
        { model: Supplier }
      ],
      order: [['createdAt', 'DESC']]
    });

    // Prepare data for CSV
    const csvData = purchaseData.map(purchase => ({
      'PO Number': purchase.kode,
      'Date': formatDate(purchase.createdAt),
      'Supplier': purchase.Supplier?.nama || 'Unknown',
      'Buyer': 'System', // Since there's no User association
      'Total Items': purchase.items.reduce((sum, item) => sum + item.qty, 0),
      'Status': purchase.status || 'Pending',
      'Notes': purchase.catatan || ''
    }));

    const headers = [
      { key: 'PO Number', label: 'PO Number' },
      { key: 'Date', label: 'Date' },
      { key: 'Supplier', label: 'Supplier' },
      { key: 'Buyer', label: 'Buyer' },
      { key: 'Total Items', label: 'Total Items' },
      { key: 'Status', label: 'Status' },
      { key: 'Notes', label: 'Notes' }
    ];

    const csv = convertToCSV(csvData, headers);
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=purchase-report-${period}-${new Date().toISOString().split('T')[0]}.csv`);
    res.send(csv);
  } catch (error) {
    console.error('Error exporting purchase report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

exports.exportInventoryReport = async (req, res) => {
  try {
    const { storeId } = req.query;

    // Get all stock data
    const stockGudangPusat = await StockGudangPusat.findAll({
      include: [
        { model: Barang, include: [{ model: Kategori }] }
      ]
    });

    let stockGudangToko = [];
    if (!storeId || storeId !== 'central') {
      let whereClause = {};
      if (storeId && storeId !== 'central') {
        whereClause.storeId = storeId;
      }
      
      stockGudangToko = await StockGudangToko.findAll({
        where: whereClause,
        include: [
          { model: Barang, include: [{ model: Kategori }] },
          { model: Store }
        ]
      });
    }

    // Determine which data to use
    let inventoryData = [];
    if (storeId === 'central') {
      inventoryData = stockGudangPusat;
    } else if (storeId) {
      inventoryData = stockGudangToko;
    } else {
      inventoryData = [...stockGudangPusat, ...stockGudangToko];
    }

    // Prepare data for CSV
    const csvData = inventoryData.map(stock => ({
      'Product Name': stock.Barang?.nama || 'Unknown',
      'SKU': stock.Barang?.sku || 'N/A',
      'Category': stock.Barang?.Kategori?.nama || 'Unknown',
      'Location': stock.Store?.nama || 'Central Warehouse',
      'Current Stock': stock.stok || 0,
      'Minimum Stock': stock.minimum_stock || 10,
      'Unit Cost': formatCurrency(stock.Barang?.harga_beli || 0),
      'Total Value': formatCurrency((stock.stok || 0) * (stock.Barang?.harga_beli || 0)),
      'Status': stock.stok <= 0 ? 'Out of Stock' : stock.stok <= (stock.minimum_stock || 10) ? 'Low Stock' : 'In Stock'
    }));

    const headers = [
      { key: 'Product Name', label: 'Product Name' },
      { key: 'SKU', label: 'SKU' },
      { key: 'Category', label: 'Category' },
      { key: 'Location', label: 'Location' },
      { key: 'Current Stock', label: 'Current Stock' },
      { key: 'Minimum Stock', label: 'Minimum Stock' },
      { key: 'Unit Cost', label: 'Unit Cost' },
      { key: 'Total Value', label: 'Total Value' },
      { key: 'Status', label: 'Status' }
    ];

    const csv = convertToCSV(csvData, headers);
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=inventory-report-${storeId || 'all'}-${new Date().toISOString().split('T')[0]}.csv`);
    res.send(csv);
  } catch (error) {
    console.error('Error exporting inventory report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

exports.exportFinancialReport = async (req, res) => {
  try {
    const { period = 'month' } = req.query;
    const { start, end } = getDateRange(period);

    // Get sales data
    const salesData = await Sale.findAll({
      where: {
        createdAt: { [Op.between]: [start, end] }
      },
      include: [
        { model: SaleItem, as: 'items' },
        { model: Store, as: 'store' }
      ]
    });

    // Get purchase data
    const purchaseData = await PurchaseOrder.findAll({
      where: {
        createdAt: { [Op.between]: [start, end] }
      },
      include: [
        { model: PurchaseOrderItem, as: 'items' },
        { model: Supplier }
      ]
    });

    // Calculate financial metrics
    const totalRevenue = salesData.reduce((sum, sale) => sum + parseFloat(sale.total || 0), 0);
    const totalCost = purchaseData.reduce((sum, purchase) => sum + parseFloat(purchase.total || 0), 0);
    const grossProfit = totalRevenue - totalCost;
    const profitMargin = totalRevenue > 0 ? (grossProfit / totalRevenue) * 100 : 0;

    // Prepare data for CSV
    const csvData = [
      {
        'Period': period.charAt(0).toUpperCase() + period.slice(1),
        'Start Date': formatDate(start),
        'End Date': formatDate(end),
        'Total Revenue': formatCurrency(totalRevenue),
        'Total Cost': formatCurrency(totalCost),
        'Gross Profit': formatCurrency(grossProfit),
        'Profit Margin': formatPercentage(profitMargin),
        'Total Sales': salesData.length,
        'Total Purchases': purchaseData.length
      }
    ];

    const headers = [
      { key: 'Period', label: 'Period' },
      { key: 'Start Date', label: 'Start Date' },
      { key: 'End Date', label: 'End Date' },
      { key: 'Total Revenue', label: 'Total Revenue' },
      { key: 'Total Cost', label: 'Total Cost' },
      { key: 'Gross Profit', label: 'Gross Profit' },
      { key: 'Profit Margin', label: 'Profit Margin' },
      { key: 'Total Sales', label: 'Total Sales' },
      { key: 'Total Purchases', label: 'Total Purchases' }
    ];

    const csv = convertToCSV(csvData, headers);
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=financial-report-${period}-${new Date().toISOString().split('T')[0]}.csv`);
    res.send(csv);
  } catch (error) {
    console.error('Error exporting financial report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

exports.exportProductPerformance = async (req, res) => {
  try {
    const { period = 'month', categoryId } = req.query;
    const { start, end } = getDateRange(period);

    let whereClause = {
      createdAt: {
        [Op.between]: [start, end]
      }
    };

    const salesData = await Sale.findAll({
      where: whereClause,
      include: [
        {
          model: SaleItem,
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }],
              where: categoryId ? { kategoriId: categoryId } : {}
            }
          ]
        }
      ]
    });

    // Calculate product performance
    const productPerformance = {};
    salesData.forEach(sale => {
      sale.items.forEach(item => {
        const productName = item.Barang?.nama || 'Unknown';
        if (!productPerformance[productName]) {
          productPerformance[productName] = {
            name: productName,
            sku: item.Barang?.sku || 'N/A',
            category: item.Barang?.Kategori?.nama || 'Unknown',
            quantitySold: 0,
            revenue: 0,
            averagePrice: 0,
            salesCount: 0
          };
        }
        productPerformance[productName].quantitySold += item.qty;
        productPerformance[productName].revenue += parseFloat(item.subtotal || 0);
        productPerformance[productName].salesCount++;
      });
    });

    // Calculate average price and performance score
    Object.values(productPerformance).forEach(product => {
      product.averagePrice = product.quantitySold > 0 ? product.revenue / product.quantitySold : 0;
      product.performanceScore = product.revenue > 0 ? Math.min(100, (product.revenue / 1000000) * 100) : 0;
    });

    // Prepare data for CSV
    const csvData = Object.values(productPerformance).map(product => ({
      'Product Name': product.name,
      'SKU': product.sku,
      'Category': product.category,
      'Quantity Sold': product.quantitySold,
      'Revenue': formatCurrency(product.revenue),
      'Average Price': formatCurrency(product.averagePrice),
      'Sales Count': product.salesCount,
      'Performance Score': formatPercentage(product.performanceScore)
    }));

    const headers = [
      { key: 'Product Name', label: 'Product Name' },
      { key: 'SKU', label: 'SKU' },
      { key: 'Category', label: 'Category' },
      { key: 'Quantity Sold', label: 'Quantity Sold' },
      { key: 'Revenue', label: 'Revenue' },
      { key: 'Average Price', label: 'Average Price' },
      { key: 'Sales Count', label: 'Sales Count' },
      { key: 'Performance Score', label: 'Performance Score' }
    ];

    const csv = convertToCSV(csvData, headers);
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=product-performance-${period}-${new Date().toISOString().split('T')[0]}.csv`);
    res.send(csv);
  } catch (error) {
    console.error('Error exporting product performance report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

exports.exportMovingStockReport = async (req, res) => {
  try {
    const { period = 'month' } = req.query;
    const { start, end } = getDateRange(period);

    // Get stock requests and transfers
    const stockRequests = await StockRequest.findAll({
      where: {
        createdAt: { [Op.between]: [start, end] }
      },
      include: [
        { 
          model: StockRequestItem, 
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }]
            }
          ]
        },
        { model: Store, as: 'toStore' }
      ]
    });

    const stockTransfers = await StockTransfer.findAll({
      where: {
        createdAt: { [Op.between]: [start, end] }
      },
      include: [
        { 
          model: StockTransferItem, 
          as: 'items',
          include: [
            {
              model: Barang,
              include: [{ model: Kategori }]
            }
          ]
        },
        { model: Store, as: 'toStore' },
        { model: StockRequest }
      ]
    });

    // Prepare data for CSV
    const csvData = [];

    // Add stock requests
    stockRequests.forEach(req => {
      req.items.forEach(item => {
        csvData.push({
          'Type': 'Stock Request',
          'Reference': req.kode,
          'Date': formatDate(req.createdAt),
          'From': 'Central Warehouse',
          'To': req.toStore?.nama || 'Unknown',
          'Product': item.Barang?.nama || 'Unknown',
          'SKU': item.Barang?.sku || 'N/A',
          'Category': item.Barang?.Kategori?.nama || 'Unknown',
          'Quantity': item.qty,
          'Status': req.status || 'Pending'
        });
      });
    });

    // Add stock transfers
    stockTransfers.forEach(trans => {
      trans.items.forEach(item => {
        csvData.push({
          'Type': 'Stock Transfer',
          'Reference': trans.kode,
          'Date': formatDate(trans.createdAt),
          'From': 'Central Warehouse',
          'To': trans.toStore?.nama || 'Unknown',
          'Product': item.Barang?.nama || 'Unknown',
          'SKU': item.Barang?.sku || 'N/A',
          'Category': item.Barang?.Kategori?.nama || 'Unknown',
          'Quantity': item.qty,
          'Status': trans.status || 'Pending'
        });
      });
    });

    const headers = [
      { key: 'Type', label: 'Type' },
      { key: 'Reference', label: 'Reference' },
      { key: 'Date', label: 'Date' },
      { key: 'From', label: 'From' },
      { key: 'To', label: 'To' },
      { key: 'Product', label: 'Product' },
      { key: 'SKU', label: 'SKU' },
      { key: 'Category', label: 'Category' },
      { key: 'Quantity', label: 'Quantity' },
      { key: 'Status', label: 'Status' }
    ];

    const csv = convertToCSV(csvData, headers);
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=moving-stock-report-${period}-${new Date().toISOString().split('T')[0]}.csv`);
    res.send(csv);
  } catch (error) {
    console.error('Error exporting moving stock report:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};