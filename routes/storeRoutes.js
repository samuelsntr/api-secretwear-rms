const express = require('express');
const router = express.Router();
const storeController = require('../controllers/storeController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), storeController.getAll);
router.get('/active', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), storeController.getActiveStores);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), storeController.getById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), storeController.create);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), storeController.update);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), storeController.delete);
router.patch('/:id/toggle-status', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), storeController.toggleStatus);

module.exports = router;