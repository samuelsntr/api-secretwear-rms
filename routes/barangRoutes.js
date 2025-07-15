const express = require('express');
const router = express.Router();
const barangController = require('../controllers/barangController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), barangController.getAllBarang);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang', 'staff_sales']), barangController.getBarangById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), barangController.createBarang);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), barangController.updateBarang);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), barangController.deleteBarang);

module.exports = router;