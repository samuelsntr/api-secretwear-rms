const express = require('express');
const router = express.Router();
const logController = require('../controllers/logController');
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// All log routes require admin/owner access
const adminOnly = hasPrivilege(['admin', 'owner']);

// Get all logs with filtering and pagination
router.get('/', isAuthenticated, adminOnly, logController.getLogs);

// Get log statistics
router.get('/stats', isAuthenticated, adminOnly, logController.getLogStats);

// Get log by ID
router.get('/:id', isAuthenticated, adminOnly, logController.getLogById);

// Delete logs (admin only)
router.delete('/', isAuthenticated, adminOnly, logController.deleteLogs);

// Clear old logs (admin only)
router.delete('/clear', isAuthenticated, adminOnly, logController.clearOldLogs);

// Export logs
router.get('/export', isAuthenticated, adminOnly, logController.exportLogs);

module.exports = router; 