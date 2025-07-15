const express = require('express');
const router = express.Router();
const stockGudangPusatController = require('../controllers/stockGudangPusatController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Inventory management - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockGudangPusatController.getAllStockGudangPusat);
router.get('/low-stock', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockGudangPusatController.getLowStockGudangPusat);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockGudangPusatController.getStockGudangPusatById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), stockGudangPusatController.createStockGudangPusat);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockGudangPusatController.updateStockGudangPusat);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockGudangPusatController.deleteStockGudangPusat);

module.exports = router;