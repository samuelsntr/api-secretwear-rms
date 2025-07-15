const express = require('express');
const router = express.Router();
const purchaseOrderController = require('../controllers/purchaseOrderController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Purchase management - full access for staff_gudang, admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseOrderController.getAll);
router.get('/available-for-gr', purchaseOrderController.getAvailableForGoodReceipt);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseOrderController.getById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseOrderController.create);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseOrderController.update);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), purchaseOrderController.delete);
router.post('/from-pr/:purchaseRequestId', purchaseOrderController.createFromPurchaseRequest);

module.exports = router;
