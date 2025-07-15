const express = require('express');
const router = express.Router();
const stockRequestController = require('../controllers/stockRequestController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Inventory management - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockRequestController.getAllStockRequests);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), stockRequestController.getStockRequestById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), stockRequestController.createStockRequest);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockRequestController.updateStockRequest);
router.put('/:id/status', isAuthenticated, hasPrivilege(['admin', 'owner']), stockRequestController.updateStockRequestStatus);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), stockRequestController.deleteStockRequest);

module.exports = router;