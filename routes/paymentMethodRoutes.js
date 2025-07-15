const express = require('express');
const router = express.Router();
const paymentMethodController = require('../controllers/paymentMethodController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Master data - read-only for staff_gudang, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), paymentMethodController.getAll);
router.get('/active', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), paymentMethodController.getActive);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), paymentMethodController.getById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), paymentMethodController.create);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), paymentMethodController.update);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), paymentMethodController.delete);

module.exports = router;