'use strict';
module.exports = (sequelize, DataTypes) => {
  const PurchaseReturnItem = sequelize.define('PurchaseReturnItem', {
    purchaseReturnId: DataTypes.INTEGER,
    barangId: DataTypes.INTEGER,
    qty: DataTypes.INTEGER,
    unit_price: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0.00,
    },
    subtotal: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0.00,
    },
    return_reason: DataTypes.TEXT,
  }, {
    tableName: 'purchase_return_items',
    freezeTableName: true,
  });

  PurchaseReturnItem.associate = function(models) {
    PurchaseReturnItem.belongsTo(models.PurchaseReturn, {
      foreignKey: 'purchaseReturnId',
      onDelete: 'CASCADE',
    });

    PurchaseReturnItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return PurchaseReturnItem;
};
