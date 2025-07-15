'use strict';
module.exports = (sequelize, DataTypes) => {
  const PurchaseRequestItem = sequelize.define('PurchaseRequestItem', {
    purchaseRequestId: {
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
    satuan: {
      type: DataTypes.STRING,
    },
    keterangan: {
      type: DataTypes.TEXT,
    }
  }, {
    tableName: 'purchase_request_items',
    freezeTableName: true,
  });

  PurchaseRequestItem.associate = function(models) {
    PurchaseRequestItem.belongsTo(models.PurchaseRequest, {
      foreignKey: 'purchaseRequestId',
      onDelete: 'CASCADE',
    });

    PurchaseRequestItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return PurchaseRequestItem;
};
