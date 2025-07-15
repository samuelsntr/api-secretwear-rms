const express = require('express');
const router = express.Router();
const kategoriController = require('../controllers/kategoriController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), kategoriController.getAllKategori);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), kategoriController.getKategoriById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), kategoriController.createKategori);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), kategoriController.updateKategori);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), kategoriController.deleteKategori);

module.exports = router;
