const express = require('express');
const router = express.Router();
const stockTransferController = require('../controllers/stockTransferController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Inventory management - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockTransferController.getAllStockTransfers);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockTransferController.getStockTransferById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), stockTransferController.createStockTransfer);
router.put('/:id/status', isAuthenticated, hasPrivilege(['admin', 'owner']), stockTransferController.updateStockTransferStatus);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockTransferController.deleteStockTransfer);

module.exports = router;