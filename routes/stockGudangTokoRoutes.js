const express = require('express');
const router = express.Router();
const stockGudangTokoController = require('../controllers/stockGudangTokoController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Inventory management - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), stockGudangTokoController.getAllStockGudangToko);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), stockGudangTokoController.getStockGudangTokoById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), stockGudangTokoController.createStockGudangToko);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockGudangTokoController.updateStockGudangToko);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockGudangTokoController.deleteStockGudangToko);

module.exports = router;