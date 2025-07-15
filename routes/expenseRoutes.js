const express = require('express');
const router = express.Router();
const expenseController = require('../controllers/expenseController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Expense routes - read for staff, full access for admin/owner
router.get('/', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), expenseController.getAllExpenses);
router.get('/:id', isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_gudang']), expenseController.getExpenseById);
router.post('/', isAuthenticated, hasPrivilege(['admin', 'owner']), expenseController.createExpense);
router.put('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), expenseController.updateExpense);
router.delete('/:id', isAuthenticated, hasPrivilege(['admin', 'owner']), expenseController.deleteExpense);

module.exports = router; 