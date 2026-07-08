exports.isAuthenticated = (req, res, next) => {
  if (req.session.user) return next();
  return res.status(401).json({ message: 'Belum login' });
};
  
exports.isAdmin = (req, res, next) => {
  const role = String(req.session.user?.role || '').toLowerCase().trim();
  if (role === 'admin') return next();
  return res.status(403).json({ message: 'Hanya admin yang diizinkan' });
};
  
exports.isOwnerOrAdmin = (req, res, next) => {
  const role = String(req.session.user?.role || '').toLowerCase().trim();
  if (role === 'admin' || role === 'owner') return next();
  return res.status(403).json({ message: 'Hanya owner atau admin yang diizinkan' });
};

exports.isStaffGudang = (req, res, next) => {
  const role = String(req.session.user?.role || '').toLowerCase().trim();
  if (role === 'staff_gudang' || role === 'admin' || role === 'owner') return next();
  return res.status(403).json({ message: 'Hanya staff gudang yang diizinkan' });
};

exports.isStaffSales = (req, res, next) => {
  const role = String(req.session.user?.role || '').toLowerCase().trim();
  if (role === 'staff_sales' || role === 'admin' || role === 'owner') return next();
  return res.status(403).json({ message: 'Hanya staff sales yang diizinkan' });
};

exports.hasPrivilege = (roles) => (req, res, next) => {
  const user = req.session.user;
  if (!user) return res.status(401).json({ message: 'Belum login' });

  const userRole = String(user.role || '').toLowerCase().trim();
  if (userRole === 'admin' || userRole === 'owner') return next();

  const allowedRoles = Array.isArray(roles)
    ? roles.map(r => String(r).toLowerCase().trim())
    : [String(roles).toLowerCase().trim()];
  if (allowedRoles.includes(userRole)) return next();

  // Check custom user permissions if configured
  const perms = user.permissions || {};
  const menus = perms.menus || {};
  if (Object.values(menus).some(val => val === true)) return next();

  return res.status(403).json({ message: 'Akses ditolak' });
};
  