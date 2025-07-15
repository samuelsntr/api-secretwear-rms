const express = require('express');
const router = express.Router();
const warnaController = require('../controllers/warnaController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), warnaController.getAllWarna);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), warnaController.getWarnaById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), warnaController.createWarna);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), warnaController.updateWarna);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), warnaController.deleteWarna);

module.exports = router;
