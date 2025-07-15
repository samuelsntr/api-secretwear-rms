const { Log, User } = require('../models');

class LogService {
  /**
   * Create a log entry
   * @param {Object} logData - Log data object
   * @param {number} logData.userId - User ID (optional)
   * @param {string} logData.action - Action performed
   * @param {string} logData.module - Module name
   * @param {string} logData.level - Log level (info, warning, error, success)
   * @param {string} logData.description - Description of the action
   * @param {Object} logData.details - Additional details (optional)
   * @param {string} logData.ipAddress - IP address (optional)
   * @param {string} logData.userAgent - User agent (optional)
   * @param {string} logData.resourceType - Resource type (optional)
   * @param {number} logData.resourceId - Resource ID (optional)
   * @param {Object} logData.oldValues - Old values for updates (optional)
   * @param {Object} logData.newValues - New values for updates (optional)
   * @param {string} logData.sessionId - Session ID (optional)
   */
  static async createLog(logData) {
    try {
      const log = await Log.create(logData);
      return log;
    } catch (error) {
      console.error('Error creating log:', error);
      // Don't throw error to avoid breaking the main functionality
    }
  }

  /**
   * Log user login
   */
  static async logLogin(userId, ipAddress, userAgent, sessionId) {
    return this.createLog({
      userId,
      action: 'LOGIN',
      module: 'AUTH',
      level: 'success',
      description: 'User logged in successfully',
      ipAddress,
      userAgent,
      sessionId,
    });
  }

  /**
   * Log user logout
   */
  static async logLogout(userId, ipAddress, sessionId) {
    return this.createLog({
      userId,
      action: 'LOGOUT',
      module: 'AUTH',
      level: 'info',
      description: 'User logged out',
      ipAddress,
      sessionId,
    });
  }

  /**
   * Log failed login attempt
   */
  static async logFailedLogin(email, ipAddress, userAgent, reason) {
    return this.createLog({
      action: 'LOGIN_FAILED',
      module: 'AUTH',
      level: 'warning',
      description: `Failed login attempt for ${email}: ${reason}`,
      ipAddress,
      userAgent,
      details: { email, reason },
    });
  }

  /**
   * Log CRUD operations
   */
  static async logCreate(userId, resourceType, resourceId, data, ipAddress) {
    return this.createLog({
      userId,
      action: 'CREATE',
      module: resourceType.toUpperCase(),
      level: 'success',
      description: `Created new ${resourceType}`,
      resourceType,
      resourceId,
      newValues: data,
      ipAddress,
    });
  }

  static async logUpdate(userId, resourceType, resourceId, oldData, newData, ipAddress) {
    return this.createLog({
      userId,
      action: 'UPDATE',
      module: resourceType.toUpperCase(),
      level: 'info',
      description: `Updated ${resourceType}`,
      resourceType,
      resourceId,
      oldValues: oldData,
      newValues: newData,
      ipAddress,
    });
  }

  static async logDelete(userId, resourceType, resourceId, data, ipAddress) {
    return this.createLog({
      userId,
      action: 'DELETE',
      module: resourceType.toUpperCase(),
      level: 'warning',
      description: `Deleted ${resourceType}`,
      resourceType,
      resourceId,
      oldValues: data,
      ipAddress,
    });
  }

  /**
   * Log sales operations
   */
  static async logSale(userId, saleId, action, details, ipAddress) {
    return this.createLog({
      userId,
      action,
      module: 'SALES',
      level: 'success',
      description: `Sales ${action.toLowerCase()}`,
      resourceType: 'sale',
      resourceId: saleId,
      details,
      ipAddress,
    });
  }

  /**
   * Log purchase operations
   */
  static async logPurchase(userId, purchaseId, action, details, ipAddress) {
    return this.createLog({
      userId,
      action,
      module: 'PURCHASE',
      level: 'success',
      description: `Purchase ${action.toLowerCase()}`,
      resourceType: 'purchase',
      resourceId: purchaseId,
      details,
      ipAddress,
    });
  }

  /**
   * Log inventory operations
   */
  static async logInventory(userId, action, details, ipAddress) {
    return this.createLog({
      userId,
      action,
      module: 'INVENTORY',
      level: 'info',
      description: `Inventory ${action.toLowerCase()}`,
      details,
      ipAddress,
    });
  }

  /**
   * Log stock movements
   */
  static async logStockMovement(userId, action, details, ipAddress) {
    return this.createLog({
      userId,
      action,
      module: 'STOCK_MOVEMENT',
      level: 'info',
      description: `Stock movement: ${action.toLowerCase()}`,
      details,
      ipAddress,
    });
  }

  /**
   * Log system errors
   */
  static async logError(error, userId, module, action, ipAddress) {
    return this.createLog({
      userId,
      action: action || 'ERROR',
      module: module || 'SYSTEM',
      level: 'error',
      description: error.message || 'System error occurred',
      details: {
        stack: error.stack,
        name: error.name,
        code: error.code,
      },
      ipAddress,
    });
  }

  /**
   * Log security events
   */
  static async logSecurityEvent(userId, action, details, ipAddress) {
    return this.createLog({
      userId,
      action,
      module: 'SECURITY',
      level: 'warning',
      description: `Security event: ${action}`,
      details,
      ipAddress,
    });
  }

  /**
   * Log report access
   */
  static async logReportAccess(userId, reportType, filters, ipAddress) {
    return this.createLog({
      userId,
      action: 'REPORT_ACCESS',
      module: 'REPORTS',
      level: 'info',
      description: `Accessed ${reportType} report`,
      details: { reportType, filters },
      ipAddress,
    });
  }

  /**
   * Get logs with filtering and pagination
   */
  static async getLogs(filters = {}, page = 1, limit = 50) {
    const offset = (page - 1) * limit;
    const whereClause = {};

    if (filters.userId) whereClause.userId = filters.userId;
    if (filters.action) whereClause.action = filters.action;
    if (filters.module) whereClause.module = filters.module;
    if (filters.level) whereClause.level = filters.level;
    if (filters.resourceType) whereClause.resourceType = filters.resourceType;
    if (filters.startDate || filters.endDate) {
      whereClause.createdAt = {};
      if (filters.startDate) {
        whereClause.createdAt[require('sequelize').Op.gte] = filters.startDate;
      }
      if (filters.endDate) {
        // Add one day to include the end date
        const endDate = new Date(filters.endDate);
        endDate.setDate(endDate.getDate() + 1);
        whereClause.createdAt[require('sequelize').Op.lt] = endDate;
      }
    }

    const { count, rows } = await Log.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'username', 'role']
        }
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset),
      distinct: true
    });

    return {
      logs: rows,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(count / limit),
        totalItems: count,
        itemsPerPage: parseInt(limit),
        hasNextPage: page * limit < count,
        hasPrevPage: page > 1
      }
    };
  }

  /**
   * Get log statistics
   */
  static async getLogStats(period = 'month') {
    const { Op } = require('sequelize');
    const now = new Date();
    let startDate;

    switch (period) {
      case 'today':
        startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        break;
      case 'week':
        startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        break;
      case 'month':
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
        break;
      case 'year':
        startDate = new Date(now.getFullYear(), 0, 1);
        break;
      default:
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    }

    const whereClause = {
      createdAt: {
        [Op.gte]: startDate
      }
    };

    const [totalLogs, errorLogs, warningLogs, successLogs, moduleStats] = await Promise.all([
      Log.count({ where: whereClause }),
      Log.count({ where: { ...whereClause, level: 'error' } }),
      Log.count({ where: { ...whereClause, level: 'warning' } }),
      Log.count({ where: { ...whereClause, level: 'success' } }),
      Log.findAll({
        where: whereClause,
        attributes: [
          'module',
          [require('sequelize').fn('COUNT', require('sequelize').col('id')), 'count']
        ],
        group: ['module'],
        order: [[require('sequelize').fn('COUNT', require('sequelize').col('id')), 'DESC']]
      })
    ]);

    return {
      totalLogs,
      errorLogs,
      warningLogs,
      successLogs,
      infoLogs: totalLogs - errorLogs - warningLogs - successLogs,
      moduleStats
    };
  }
}

module.exports = LogService; 