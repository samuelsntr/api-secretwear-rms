const express = require("express");
const router = express.Router();
const saleController = require("../controllers/saleController");
const { isAuthenticated, hasPrivilege } = require('../middleware/auth');

// Sales management - read-only for staff_sales, full access for admin/owner
router.get("/", isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), saleController.getAll);
router.get("/:id", isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), saleController.getById);
router.post("/", isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), saleController.create);
router.delete("/:id", isAuthenticated, hasPrivilege(['admin', 'owner', 'staff_sales']), saleController.delete);

module.exports = router;