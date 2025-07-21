const express = require('express');
const router = express.Router();
const ukuranController = require('../controllers/ukuranController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), ukuranController.getAllUkuran);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), ukuranController.getUkuranById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), ukuranController.createUkuran);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), ukuranController.updateUkuran);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), ukuranController.deleteUkuran);

module.exports = router;
