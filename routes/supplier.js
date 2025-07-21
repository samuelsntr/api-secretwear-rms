const express = require('express');
const router = express.Router();
const supplierController = require('../controllers/supplierController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), supplierController.getAllSupplier);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), supplierController.getSupplierById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), supplierController.createSupplier);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), supplierController.updateSupplier);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), supplierController.deleteSupplier);

module.exports = router;
