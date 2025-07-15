'use strict';
module.exports = (sequelize, DataTypes) => {
  const PurchaseOrderItem = sequelize.define('PurchaseOrderItem', {
    purchaseOrderId: DataTypes.INTEGER,
    barangId: DataTypes.INTEGER,
    qty: DataTypes.INTEGER,
    harga: DataTypes.DECIMAL(15, 2),
    subtotal: DataTypes.DECIMAL(15, 2),
  }, {
    tableName: 'purchase_order_items',
    freezeTableName: true,
  });

  PurchaseOrderItem.associate = function(models) {
    PurchaseOrderItem.belongsTo(models.PurchaseOrder, {
      foreignKey: 'purchaseOrderId',
      onDelete: 'CASCADE',
    });

    PurchaseOrderItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return PurchaseOrderItem;
};
