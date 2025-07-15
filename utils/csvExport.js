/**
 * CSV Export Utility Functions
 */

/**
 * Convert data to CSV format
 * @param {Array} data - Array of objects to convert
 * @param {Array} headers - Array of header objects with key and label
 * @param {string} filename - Default filename for the export
 * @returns {string} CSV string
 */
function convertToCSV(data, headers, filename = 'export') {
  if (!data || !Array.isArray(data) || data.length === 0) {
    return '';
  }

  // Create header row
  const headerRow = headers.map(header => `"${header.label}"`).join(',');
  
  // Create data rows
  const dataRows = data.map(row => {
    return headers.map(header => {
      const value = row[header.key];
      // Handle different data types
      if (value === null || value === undefined) {
        return '""';
      }
      if (typeof value === 'number') {
        return value.toString();
      }
      if (typeof value === 'boolean') {
        return value ? 'Yes' : 'No';
      }
      // Escape quotes in string values
      return `"${String(value).replace(/"/g, '""')}"`;
    }).join(',');
  });

  return [headerRow, ...dataRows].join('\n');
}

/**
 * Format currency for CSV export
 * @param {number} amount - Amount to format
 * @returns {string} Formatted currency string
 */
function formatCurrency(amount) {
  if (amount === null || amount === undefined) return '0';
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

/**
 * Format date for CSV export
 * @param {string|Date} date - Date to format
 * @returns {string} Formatted date string
 */
function formatDate(date) {
  if (!date) return '';
  const d = new Date(date);
  return d.toLocaleDateString('id-ID', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
}

/**
 * Format percentage for CSV export
 * @param {number} value - Value to format as percentage
 * @returns {string} Formatted percentage string
 */
function formatPercentage(value) {
  if (value === null || value === undefined) return '0%';
  return `${value.toFixed(2)}%`;
}

module.exports = {
  convertToCSV,
  formatCurrency,
  formatDate,
  formatPercentage,
}; 