'use strict';

module.exports = (sequelize, DataTypes) => {
  const Sale = sequelize.define('Sale', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    tanggal: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    total: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      defaultValue: 0,
    },
    paymentMethodId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    catatan: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    storeId: DataTypes.INTEGER,
    discount_mode: {
      type: DataTypes.ENUM('item', 'bill'),
      allowNull: false,
      defaultValue: 'item',
    },
    bill_discount_percent: {
      type: DataTypes.FLOAT,
      allowNull: false,
      defaultValue: 0,
    },
  }, {
    tableName: 'sales',
    freezeTableName: true,
  });

  Sale.associate = function (models) {
    Sale.hasMany(models.SaleItem, {
      foreignKey: 'saleId',
      as: 'items',
      onDelete: 'CASCADE',
    });
    Sale.belongsTo(models.User, {
      foreignKey: 'userId',
    });
    Sale.belongsTo(models.PaymentMethod, {
      foreignKey: 'paymentMethodId',
      as: 'paymentMethod',
    });
    Sale.belongsTo(models.Store, {
      foreignKey: 'storeId',
      as: 'store',
    });
  };

  return Sale;
};
