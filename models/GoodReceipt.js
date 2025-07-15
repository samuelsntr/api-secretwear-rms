'use strict';
module.exports = (sequelize, DataTypes) => {
  const GoodReceipt = sequelize.define('GoodReceipt', {
    kode: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false,
    },
    tanggal: DataTypes.DATEONLY,
    purchaseOrderId: DataTypes.INTEGER,
    catatan: DataTypes.TEXT,
    status: {
      type: DataTypes.ENUM('outstanding', 'closed'),
      defaultValue: 'outstanding',
    },
  }, {
    tableName: 'good_receipts',
    freezeTableName: true,
  });

  GoodReceipt.associate = function(models) {
    GoodReceipt.belongsTo(models.PurchaseOrder, {
      foreignKey: 'purchaseOrderId',
    });

    GoodReceipt.hasMany(models.GoodReceiptItem, {
      foreignKey: 'goodReceiptId',
      as: 'items',
      onDelete: 'CASCADE',
    });
  };

  return GoodReceipt;
};
