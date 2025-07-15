'use strict';

module.exports = (sequelize, DataTypes) => {
  const SaleReturnItem = sequelize.define('SaleReturnItem', {
    saleReturnId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    barangId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    qty: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    harga: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
    },
    subtotal: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
    },
    return_reason: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  }, {
    tableName: 'sale_return_items',
    freezeTableName: true,
  });

  SaleReturnItem.associate = function (models) {
    SaleReturnItem.belongsTo(models.SaleReturn, {
      foreignKey: 'saleReturnId',
      onDelete: 'CASCADE',
    });
    SaleReturnItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return SaleReturnItem;
};
