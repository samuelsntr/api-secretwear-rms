const { Company } = require('../models');
const LogService = require('../services/logService');

const getCompanyInfo = async (req, res) => {
  try {
    const company = await Company.findOne();
    if (!company) {
      return res.status(404).json({ message: 'Company information not found' });
    }
    res.json(company);
  } catch (error) {
    // Log error
    LogService.logError(
      error,
      req.user?.id,
      'COMPANY',
      'GET_INFO',
      req.ip || req.connection.remoteAddress
    );
    console.error('Error fetching company info:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

const updateCompanyInfo = async (req, res) => {
  try {
    const { nama, alamat, phone, email } = req.body;
    
    let company = await Company.findOne();
    if (!company) {
      // Create new company if none exists
      company = await Company.create({ nama, alamat, phone, email });
      
      // Log successful creation
      LogService.logCreate(
        req.user?.id,
        'company',
        company.id,
        { nama, alamat, phone, email },
        req.ip || req.connection.remoteAddress
      );
    } else {
      // Update existing company
      const oldData = {
        nama: company.nama,
        alamat: company.alamat,
        phone: company.phone,
        email: company.email
      };
      
      await company.update({ nama, alamat, phone, email });
      
      // Log successful update
      LogService.logUpdate(
        req.user?.id,
        'company',
        company.id,
        oldData,
        { nama, alamat, phone, email },
        req.ip || req.connection.remoteAddress
      );
    }
    
    res.json({ message: 'Company information updated successfully', company });
  } catch (error) {
    // Log error
    LogService.logError(
      error,
      req.user?.id,
      'COMPANY',
      'UPDATE_INFO',
      req.ip || req.connection.remoteAddress
    );
    console.error('Error updating company info:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

module.exports = {
  getCompanyInfo,
  updateCompanyInfo,
}; 