const LogService = require('../services/logService');

// Get all logs with filtering and pagination
exports.getLogs = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 50,
      userId,
      action,
      module,
      level,
      resourceType,
      startDate,
      endDate,
    } = req.query;

    const filters = {
      userId: userId ? parseInt(userId) : null,
      action,
      module,
      level,
      resourceType,
      startDate: startDate ? new Date(startDate) : null,
      endDate: endDate ? new Date(endDate) : null,
    };

    // Remove null filters
    Object.keys(filters).forEach(key => {
      if (filters[key] === null) {
        delete filters[key];
      }
    });


    const result = await LogService.getLogs(filters, page, limit);

    res.json({
      success: true,
      data: result.logs,
      pagination: result.pagination,
    });
  } catch (error) {
    console.error('Error getting logs:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Get log statistics
exports.getLogStats = async (req, res) => {
  try {
    const { period = 'month' } = req.query;
    const stats = await LogService.getLogStats(period);

    res.json({
      success: true,
      data: stats,
    });
  } catch (error) {
    console.error('Error getting log stats:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Get log by ID
exports.getLogById = async (req, res) => {
  try {
    const { Log, User } = require('../models');
    const log = await Log.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'role'],
        },
      ],
    });

    if (!log) {
      return res.status(404).json({ success: false, message: 'Log not found' });
    }

    res.json({
      success: true,
      data: log,
    });
  } catch (error) {
    console.error('Error getting log by ID:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Delete logs (admin only)
exports.deleteLogs = async (req, res) => {
  try {
    const { Log } = require('../models');
    const { ids } = req.body || {};

    console.log('Delete logs request body:', req.body);
    console.log('Delete logs request query:', req.query);

    let deletedCount;
    
    if (ids && Array.isArray(ids) && ids.length > 0) {
      // Delete specific logs by IDs
      console.log('Deleting specific logs with IDs:', ids);
      deletedCount = await Log.destroy({
        where: {
          id: ids,
        },
      });
    } else {
      // Delete all logs when no IDs provided or empty array
      console.log('Deleting all logs');
      deletedCount = await Log.destroy({
        where: {},
      });
    }

    console.log('Deleted count:', deletedCount);

    res.json({
      success: true,
      message: `Successfully deleted ${deletedCount} logs`,
      deletedCount,
    });
  } catch (error) {
    console.error('Error deleting logs:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Clear old logs (admin only)
exports.clearOldLogs = async (req, res) => {
  try {
    const { Log } = require('../models');
    const { days = 30 } = req.body;

    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const deletedCount = await Log.destroy({
      where: {
        createdAt: {
          [require('sequelize').Op.lt]: cutoffDate,
        },
      },
    });

    res.json({
      success: true,
      message: `Successfully cleared ${deletedCount} logs older than ${days} days`,
      deletedCount,
    });
  } catch (error) {
    console.error('Error clearing old logs:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Export logs
exports.exportLogs = async (req, res) => {
  try {
    const { format = 'json' } = req.query;
    const result = await LogService.getLogs({}, 1, 10000); // Get all logs

    if (format === 'csv') {
      const csv = convertToCSV(result.logs);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', 'attachment; filename=logs.csv');
      res.send(csv);
    } else {
      res.json({
        success: true,
        data: result.logs,
      });
    }
  } catch (error) {
    console.error('Error exporting logs:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Helper function to convert logs to CSV
function convertToCSV(logs) {
  const headers = [
    'ID',
    'User',
    'Action',
    'Module',
    'Level',
    'Description',
    'IP Address',
    'Resource Type',
    'Resource ID',
    'Created At',
  ];

  const rows = logs.map(log => [
    log.id,
    log.user?.nama || 'System',
    log.action,
    log.module,
    log.level,
    log.description,
    log.ipAddress || '',
    log.resourceType || '',
    log.resourceId || '',
    log.createdAt,
  ]);

  return [headers, ...rows]
    .map(row => row.map(cell => `"${cell}"`).join(','))
    .join('\n');
} 