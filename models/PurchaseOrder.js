'use strict';
module.exports = (sequelize, DataTypes) => {
  const PurchaseOrder = sequelize.define('PurchaseOrder', {
    kode: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false,
    },
    tanggal: DataTypes.DATEONLY,
    status: {
      type: DataTypes.ENUM('draft', 'dikirim', 'partial_received', 'diterima', 'dibatalkan'),
      defaultValue: 'draft',
    },
    catatan: DataTypes.TEXT,
    purchaseRequestId: DataTypes.INTEGER,
    supplierId: DataTypes.INTEGER,
  }, {
    tableName: 'purchase_orders',
    freezeTableName: true,
  });

  PurchaseOrder.associate = function(models) {
    PurchaseOrder.hasMany(models.PurchaseOrderItem, {
      foreignKey: 'purchaseOrderId',
      as: 'items',
      onDelete: 'CASCADE',
    });

    PurchaseOrder.belongsTo(models.PurchaseRequest, {
      foreignKey: 'purchaseRequestId',
    });

    PurchaseOrder.belongsTo(models.Supplier, {
      foreignKey: 'supplierId',
    });
  };

  return PurchaseOrder;
};
