const express = require('express');
const router = express.Router();
const goodReceiptController = require('../controllers/goodReceiptController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Purchase management - full access for staff_gudang, admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), goodReceiptController.getAll);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), goodReceiptController.getById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), goodReceiptController.create);
router.put('/:id/status', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), goodReceiptController.updateStatus);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), goodReceiptController.delete);

// Get remaining quantities for a PO
router.get('/po/:poId/remaining', goodReceiptController.getPORemainingQuantities);

module.exports = router;
