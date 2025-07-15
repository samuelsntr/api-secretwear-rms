const express = require("express");
const router = express.Router();
const controller = require("../controllers/saleReturnController");

router.get("/", controller.getAll);
router.get("/available-sales", controller.getAvailableSales);
router.get("/sale/:saleId/discounted-prices", controller.getSaleWithDiscountedPrices);
router.get("/:id", controller.getById);
router.post("/", controller.create);
router.put("/:id/status", controller.updateStatus);
router.delete("/:id", controller.delete);

module.exports = router;