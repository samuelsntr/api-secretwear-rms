'use strict';

module.exports = (sequelize, DataTypes) => {
  const Expense = sequelize.define('Expense', {
    date: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
    amount: {
      type: DataTypes.DECIMAL(12,2),
      allowNull: false,
    },
    category: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  }, {
    tableName: 'expenses',
    freezeTableName: true,
  });

  return Expense;
}; 