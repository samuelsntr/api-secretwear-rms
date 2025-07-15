'use strict';

module.exports = (sequelize, DataTypes) => {
  const SaleReturn = sequelize.define('SaleReturn', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    tanggal: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
    saleId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    storeId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    total_return: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      defaultValue: 0,
    },
    return_reason: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    refund_method: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    refundMethodId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM('pending', 'approved', 'completed'),
      defaultValue: 'pending',
    },
  }, {
    tableName: 'sale_returns',
    freezeTableName: true,
  });

  SaleReturn.associate = function (models) {
    SaleReturn.belongsTo(models.Sale, { foreignKey: 'saleId' });
    SaleReturn.belongsTo(models.User, { foreignKey: 'userId' });
    SaleReturn.belongsTo(models.PaymentMethod, {
      foreignKey: 'refundMethodId',
      as: 'refundMethod',
    });
    SaleReturn.hasMany(models.SaleReturnItem, {
      foreignKey: 'saleReturnId',
      as: 'items',
      onDelete: 'CASCADE',
    });
  };

  return SaleReturn;
};
