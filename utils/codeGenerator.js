const codeGeneratorService = require('../services/codeGeneratorService');

/**
 * Simple utility wrapper for code generation
 * Makes it easier to use in controllers with common patterns
 */

/**
 * Generate code with transaction support
 * @param {string} moduleType - Module type (e.g., 'purchase-order')
 * @param {Object} transaction - Sequelize transaction
 * @returns {Promise<string>} Generated code
 */
async function generateCode(moduleType, transaction = null) {
  return await codeGeneratorService.generateCode(moduleType, { transaction });
}

/**
 * Generate code with retry logic for controllers
 * This is the recommended method for controllers
 * @param {string} moduleType - Module type
 * @param {Object} transaction - Sequelize transaction
 * @param {number} maxRetries - Maximum retry attempts
 * @returns {Promise<string>} Generated code
 */
async function generateCodeWithRetry(moduleType, transaction = null, maxRetries = 3) {
  return await codeGeneratorService.generateCode(moduleType, {
    transaction,
    maxRetries
  });
}

/**
 * Generate batch codes for bulk operations
 * @param {string} moduleType - Module type
 * @param {number} count - Number of codes to generate
 * @param {Object} transaction - Sequelize transaction
 * @returns {Promise<string[]>} Array of generated codes
 */
async function generateBatchCodes(moduleType, count, transaction = null) {
  return await codeGeneratorService.generateBatchCodes(moduleType, count, { transaction });
}

/**
 * Validate code format
 * @param {string} code - Code to validate
 * @param {string} moduleType - Module type
 * @returns {boolean} Whether code is valid
 */
function validateCode(code, moduleType) {
  return codeGeneratorService.validateCodeFormat(code, moduleType);
}

/**
 * Parse code to extract information
 * @param {string} code - Code to parse
 * @returns {Object} Parsed code information
 */
function parseCode(code) {
  return codeGeneratorService.parseCode(code);
}

/**
 * Get module statistics
 * @param {string} moduleType - Module type
 * @param {string} date - Optional date (YYYYMMDD)
 * @returns {Promise<Object>} Statistics
 */
async function getStats(moduleType, date = null) {
  return await codeGeneratorService.getModuleStats(moduleType, date);
}

// Export individual functions for easy importing
module.exports = {
  generateCode,
  generateCodeWithRetry,
  generateBatchCodes,
  validateCode,
  parseCode,
  getStats,
  
  // Export the service instance for advanced usage
  service: codeGeneratorService
}; 