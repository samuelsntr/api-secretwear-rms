const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// User management - admin/owner only
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner']), userController.getUsers);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), userController.createUser);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), userController.updateUser);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), userController.deleteUser);

module.exports = router;
