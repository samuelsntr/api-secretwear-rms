const LogService = require('../services/logService');

/**
 * Middleware to log HTTP requests
 */
const logRequest = (req, res, next) => {
  const startTime = Date.now();
  
  // Capture request details
  const requestData = {
    method: req.method,
    url: req.originalUrl,
    ip: req.ip || req.connection.remoteAddress,
    userAgent: req.get('User-Agent'),
    userId: req.user?.id,
  };

  // Log the request
  LogService.createLog({
    userId: req.user?.id,
    action: 'HTTP_REQUEST',
    module: 'SYSTEM',
    level: 'info',
    description: `${req.method} ${req.originalUrl}`,
    details: requestData,
    ipAddress: req.ip || req.connection.remoteAddress,
    userAgent: req.get('User-Agent'),
  });

  // Override res.end to log response
  const originalEnd = res.end;
  res.end = function(chunk, encoding) {
    const duration = Date.now() - startTime;
    
    // Log response
    LogService.createLog({
      userId: req.user?.id,
      action: 'HTTP_RESPONSE',
      module: 'SYSTEM',
      level: res.statusCode >= 400 ? 'error' : 'info',
      description: `${req.method} ${req.originalUrl} - ${res.statusCode} (${duration}ms)`,
      details: {
        statusCode: res.statusCode,
        duration,
        requestData,
      },
      ipAddress: req.ip || req.connection.remoteAddress,
      userAgent: req.get('User-Agent'),
    });

    originalEnd.call(this, chunk, encoding);
  };

  next();
};

/**
 * Middleware to log errors
 */
const logError = (error, req, res, next) => {
  LogService.logError(
    error,
    req.user?.id,
    'SYSTEM',
    'HTTP_ERROR',
    req.ip || req.connection.remoteAddress
  );
  next(error);
};

/**
 * Middleware to log authentication events
 */
const logAuth = (req, res, next) => {
  const originalSend = res.send;
  
  res.send = function(data) {
    // Log successful login
    if (req.originalUrl.includes('/auth/login') && res.statusCode === 200) {
      try {
        const responseData = JSON.parse(data);
        if (responseData.success && responseData.user) {
          LogService.logLogin(
            responseData.user.id,
            req.ip || req.connection.remoteAddress,
            req.get('User-Agent'),
            req.sessionID
          );
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }
    
    // Log logout
    if (req.originalUrl.includes('/auth/logout') && res.statusCode === 200) {
      LogService.logLogout(
        req.user?.id,
        req.ip || req.connection.remoteAddress,
        req.sessionID
      );
    }
    
    originalSend.call(this, data);
  };
  
  next();
};

/**
 * Middleware to log CRUD operations
 */
const logCRUD = (resourceType) => {
  return (req, res, next) => {
    const originalSend = res.send;
    
    res.send = function(data) {
      try {
        const responseData = JSON.parse(data);
        
        // Log CREATE operations
        if (req.method === 'POST' && res.statusCode === 201) {
          LogService.logCreate(
            req.user?.id,
            resourceType,
            responseData.id,
            req.body,
            req.ip || req.connection.remoteAddress
          );
        }
        
        // Log UPDATE operations
        if (req.method === 'PUT' && res.statusCode === 200) {
          LogService.logUpdate(
            req.user?.id,
            resourceType,
            req.params.id,
            req.body, // For simplicity, using request body as old values
            responseData,
            req.ip || req.connection.remoteAddress
          );
        }
        
        // Log DELETE operations
        if (req.method === 'DELETE' && res.statusCode === 200) {
          LogService.logDelete(
            req.user?.id,
            resourceType,
            req.params.id,
            responseData,
            req.ip || req.connection.remoteAddress
          );
        }
      } catch (e) {
        // Ignore parsing errors
      }
      
      originalSend.call(this, data);
    };
    
    next();
  };
};

/**
 * Middleware to log report access
 */
const logReportAccess = (reportType) => {
  return (req, res, next) => {
    LogService.logReportAccess(
      req.user?.id,
      reportType,
      req.query,
      req.ip || req.connection.remoteAddress
    );
    next();
  };
};

module.exports = {
  logRequest,
  logError,
  logAuth,
  logCRUD,
  logReportAccess,
}; 