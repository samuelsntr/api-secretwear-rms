const express = require('express');
const router = express.Router();
const purchaseReturnController = require('../controllers/purchaseReturnController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Get available good receipts for returns - must come BEFORE /:id route
router.get('/available-gr', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.getAvailableGoodReceipts);

// Purchase management - full access for staff_gudang, admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.getAll);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.getById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.create);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.update);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.delete);

// Update purchase return status
router.put('/:id/status', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseReturnController.updateStatus);

module.exports = router;
