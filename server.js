const express = require("express");
const session = require("express-session");
const cors = require("cors");
require("dotenv").config();
const authRoutes = require("./routes/auth");
const barangRoutes = require("./routes/barangRoutes");
const supplierRoutes = require("./routes/supplier");
const laporanRoutes = require("./routes/laporan");
const userRoutes = require("./routes/user");
const kategoriRoutes = require('./routes/kategoriRoutes');
const warnaRoutes = require('./routes/warnaRoutes');
const ukuranRoutes = require('./routes/ukuranRoutes');
const purchaseRequestRoutes = require('./routes/purchaseRequestRoutes');
const purchaseOrderRoutes = require('./routes/purchaseOrderRoutes');
const goodReceiptRoutes = require('./routes/goodReceiptRoutes');
const purchaseReturnRoutes = require('./routes/purchaseReturnRoutes');
const saleRoutes = require("./routes/saleRoutes");
const saleReturnRoutes = require("./routes/saleReturnRoutes");
const stockGudangTokoRoutes = require('./routes/stockGudangTokoRoutes');
const stockGudangPusatRoutes = require('./routes/stockGudangPusatRoutes');
const stockRequestRoutes = require('./routes/stockRequestRoutes');
const stockTransferRoutes = require('./routes/stockTransferRoutes');
const storeRoutes = require('./routes/storeRoutes');
const companyRoutes = require('./routes/company');
const paymentMethodRoutes = require('./routes/paymentMethodRoutes');
const logRoutes = require('./routes/logs');
const expenseRoutes = require('./routes/expenseRoutes');
const { logRequest, logError, logAuth } = require('./middleware/logging');
const SequelizeStore = require("connect-session-sequelize")(session.Store);

const db = require("./models");

const app = express();

// Create a session store using Sequelize
const sessionStore = new SequelizeStore({
  db: db.sequelize,
  tableName: "sessions", // Optional: customize table name
});

// Konfigurasi express-session
app.use(
  session({
    secret: "your-secret-key", // Ganti dengan string acak yang kuat
    resave: false,
    saveUninitialized: false,
    store: sessionStore,
    cookie: { secure: false }, // Set to true if using HTTPS
  })
);

// Sync the session table
sessionStore.sync();

app.use(
  cors({
    origin: "http://localhost:5173",
    credentials: true,
  })
);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Logging middleware
app.use(logRequest);
app.use(logAuth);

// AUTH ROUTES
app.use("/api/auth", authRoutes);

// LAPORAN ROUTES
app.use("/api/laporan", laporanRoutes);
app.use("/api/user", userRoutes);
app.use("/api/supplier", supplierRoutes);
app.use("/api/barang", barangRoutes);
app.use('/api/kategori', kategoriRoutes);
app.use('/api/warna', warnaRoutes);
app.use('/api/ukuran', ukuranRoutes);
app.use('/api/purchase-requests', purchaseRequestRoutes);
app.use('/api/purchase-orders', purchaseOrderRoutes);
app.use('/api/good-receipts', goodReceiptRoutes);
app.use('/api/purchase-returns', purchaseReturnRoutes);
app.use("/api/sales", saleRoutes);
app.use("/api/sale-returns", saleReturnRoutes);
app.use('/api/stock-gudang-toko', stockGudangTokoRoutes);
app.use('/api/stock-gudang-pusat', stockGudangPusatRoutes);
app.use('/api/stock-requests', stockRequestRoutes);
app.use('/api/stock-transfers', stockTransferRoutes);
app.use('/api/stores', storeRoutes);
app.use('/api/companies', companyRoutes);
app.use('/api/payment-methods', paymentMethodRoutes);
app.use('/api/logs', logRoutes);
app.use('/api/expenses', expenseRoutes);

// Test route
app.get("/", (req, res) => res.send("Gudang management API running"));

// Error handling middleware
app.use(logError);

// // Connect to DB and sync
db.sequelize.sync({ alter: false }).then(() => {
  console.log("Database connected and tables synced!");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));