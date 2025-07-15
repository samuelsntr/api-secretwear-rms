exports.isAuthenticated = (req, res, next) => {
    if (req.session.user) return next();
    return res.status(401).json({ message: 'Belum login' });
  };
  
exports.isAdmin = (req, res, next) => {
  if (req.session.user?.role === 'admin') return next();
  return res.status(403).json({ message: 'Hanya admin yang diizinkan' });
  };
  
// Middleware to check if user is owner or admin
exports.isOwnerOrAdmin = (req, res, next) => {
  const role = req.session.user?.role;
  if (role === 'admin' || role === 'owner') return next();
  return res.status(403).json({ message: 'Hanya owner atau admin yang diizinkan' });
};

// Middleware to check if user is staff gudang
exports.isStaffGudang = (req, res, next) => {
  if (req.session.user?.role === 'staff_gudang') return next();
  return res.status(403).json({ message: 'Hanya staff gudang yang diizinkan' });
};

// Middleware to check if user is staff sales
exports.isStaffSales = (req, res, next) => {
  if (req.session.user?.role === 'staff_sales') return next();
  return res.status(403).json({ message: 'Hanya staff sales yang diizinkan' });
};

// Generic middleware to check if user has one of the allowed roles
exports.hasPrivilege = (roles) => (req, res, next) => {
  if (roles.includes(req.session.user?.role)) return next();
  return res.status(403).json({ message: 'Akses ditolak' });
};
  