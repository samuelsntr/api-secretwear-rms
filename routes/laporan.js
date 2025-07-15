const express = require('express');
const router = express.Router();
const laporanController = require('../controllers/laporanController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// All laporan routes require admin/owner access
const adminOnly = hasPrivilege(['admin', 'owner']);

// Dashboard Summary
router.get('/dashboard-summary', isAuthenticated, adminOnly, laporanController.getDashboardSummary);

// Sales Report
router.get('/sales', isAuthenticated, adminOnly, laporanController.getSalesReport);
router.get('/sales/export', isAuthenticated, adminOnly, laporanController.exportSalesReport);

// Purchase Report
router.get('/purchase', isAuthenticated, adminOnly, laporanController.getPurchaseReport);
router.get('/purchase/export', isAuthenticated, adminOnly, laporanController.exportPurchaseReport);

// Inventory Report
router.get('/inventory', isAuthenticated, adminOnly, laporanController.getInventoryReport);
router.get('/inventory/export', isAuthenticated, adminOnly, laporanController.exportInventoryReport);

// Financial Report
router.get('/financial', isAuthenticated, adminOnly, laporanController.getFinancialSummary);
router.get('/financial/export', isAuthenticated, adminOnly, laporanController.exportFinancialReport);

// Product Performance Report
router.get('/product-performance', isAuthenticated, adminOnly, laporanController.getProductPerformance);
router.get('/product-performance/export', isAuthenticated, adminOnly, laporanController.exportProductPerformance);

// Moving Stock Report
router.get('/moving-stock', isAuthenticated, adminOnly, laporanController.getMovingStockReport);
router.get('/moving-stock/export', isAuthenticated, adminOnly, laporanController.exportMovingStockReport);

module.exports = router;