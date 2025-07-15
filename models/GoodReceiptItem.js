'use strict';
module.exports = (sequelize, DataTypes) => {
  const GoodReceiptItem = sequelize.define('GoodReceiptItem', {
    goodReceiptId: DataTypes.INTEGER,
    barangId: DataTypes.INTEGER,
    qty_diterima: DataTypes.INTEGER,
  }, {
    tableName: 'good_receipt_items',
    freezeTableName: true,
  });

  GoodReceiptItem.associate = function(models) {
    GoodReceiptItem.belongsTo(models.GoodReceipt, {
      foreignKey: 'goodReceiptId',
      onDelete: 'CASCADE',
    });

    GoodReceiptItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return GoodReceiptItem;
};
