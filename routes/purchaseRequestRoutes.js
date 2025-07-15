const express = require('express');
const router = express.Router();
const purchaseRequestController = require('../controllers/purchaseRequestController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Purchase management - full access for staff_gudang, admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseRequestController.getAll);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseRequestController.getById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseRequestController.create);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseRequestController.update);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseRequestController.delete);
router.post('/:id/approval', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseRequestController.handleApproval);

module.exports = router;
