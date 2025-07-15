const express = require('express');
const router = express.Router();
const companyController = require('../controllers/companyController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), companyController.getCompanyInfo);
router.put('/', isAuthenticated, hasPrivilege(['admin', 'owner']), companyController.updateCompanyInfo);

module.exports = router;