const { Expense } = require('../models');
const { Op } = require('sequelize');
const LogService = require('../services/logService');

// GET all expenses
exports.getAllExpenses = async (req, res) => {
  try {
    let { search, category, startDate, endDate, page = 1, limit = 10 } = req.query;
    page = parseInt(page);
    limit = parseInt(limit);
    const offset = (page - 1) * limit;
    const whereClause = {};
    if (search) {
      whereClause.description = { [Op.like]: `%${search}%` };
    }
    if (category) {
      whereClause.category = category;
    }
    if (startDate || endDate) {
      whereClause.date = {};
      if (startDate) whereClause.date[Op.gte] = startDate;
      if (endDate) whereClause.date[Op.lte] = endDate;
    }
    const { count, rows } = await Expense.findAndCountAll({
      where: whereClause,
      limit,
      offset,
      order: [['date', 'DESC']]
    });
    // Get unique categories for filter dropdown
    const allCategories = await Expense.findAll({
      attributes: [[require('sequelize').fn('DISTINCT', require('sequelize').col('category')), 'category']],
      raw: true
    });
    const categories = allCategories.map(c => c.category).filter(Boolean);
    res.json({
      data: rows,
      pagination: {
        currentPage: page,
        totalPages: Math.ceil(count / limit),
        totalItems: count,
        itemsPerPage: limit,
        hasNextPage: page * limit < count,
        hasPrevPage: page > 1
      },
      categories
    });
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'EXPENSE',
      'GET_ALL',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil data expense', error: err.message });
  }
};

// GET expense by ID
exports.getExpenseById = async (req, res) => {
  try {
    const expense = await Expense.findByPk(req.params.id);
    if (!expense) {
      return res.status(404).json({ message: 'Expense tidak ditemukan' });
    }
    res.json(expense);
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'EXPENSE',
      'GET_BY_ID',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal mengambil expense', error: err.message });
  }
};

// POST create expense
exports.createExpense = async (req, res) => {
  try {
    const { date, amount, category, description } = req.body;
    const createdBy = req.user?.id;
    const expense = await Expense.create({ date, amount, category, description, createdBy });
    LogService.logCreate(
      createdBy,
      'expense',
      expense.id,
      { date, amount, category, description },
      req.ip || req.connection.remoteAddress
    );
    res.status(201).json({ message: 'Expense berhasil ditambahkan', expense });
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'EXPENSE',
      'CREATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menambah expense', error: err.message });
  }
};

// PUT update expense
exports.updateExpense = async (req, res) => {
  try {
    const { id } = req.params;
    const { date, amount, category, description } = req.body;
    const expense = await Expense.findByPk(id);
    if (!expense) {
      return res.status(404).json({ message: 'Expense tidak ditemukan' });
    }
    const oldData = {
      date: expense.date,
      amount: expense.amount,
      category: expense.category,
      description: expense.description
    };
    await expense.update({ date, amount, category, description });
    LogService.logUpdate(
      req.user?.id,
      'expense',
      expense.id,
      oldData,
      { date, amount, category, description },
      req.ip || req.connection.remoteAddress
    );
    res.json({ message: 'Expense berhasil diperbarui', expense });
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'EXPENSE',
      'UPDATE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal memperbarui expense', error: err.message });
  }
};

// DELETE expense
exports.deleteExpense = async (req, res) => {
  try {
    const { id } = req.params;
    const expense = await Expense.findByPk(id);
    if (!expense) {
      return res.status(404).json({ message: 'Expense tidak ditemukan' });
    }
    const expenseData = {
      id: expense.id,
      date: expense.date,
      amount: expense.amount,
      category: expense.category,
      description: expense.description
    };
    await expense.destroy();
    LogService.logDelete(
      req.user?.id,
      'expense',
      expense.id,
      expenseData,
      req.ip || req.connection.remoteAddress
    );
    res.json({ message: 'Expense berhasil dihapus' });
  } catch (err) {
    LogService.logError(
      err,
      req.user?.id,
      'EXPENSE',
      'DELETE',
      req.ip || req.connection.remoteAddress
    );
    res.status(500).json({ message: 'Gagal menghapus expense', error: err.message });
  }
}; 