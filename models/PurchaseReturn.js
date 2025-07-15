'use strict';
module.exports = (sequelize, DataTypes) => {
  const PurchaseReturn = sequelize.define('PurchaseReturn', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    tanggal: DataTypes.DATEONLY,
    goodReceiptId: DataTypes.INTEGER,
    catatan: DataTypes.TEXT,
    status: {
      type: DataTypes.ENUM('draft', 'approved', 'completed'),
      defaultValue: 'draft',
    },
    return_reason: DataTypes.TEXT,
    total_amount: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0.00,
    },
  }, {
    tableName: 'purchase_returns',
    freezeTableName: true,
  });

  PurchaseReturn.associate = function(models) {
    PurchaseReturn.belongsTo(models.GoodReceipt, {
      foreignKey: 'goodReceiptId',
    });

    PurchaseReturn.hasMany(models.PurchaseReturnItem, {
      foreignKey: 'purchaseReturnId',
      as: 'items',
      onDelete: 'CASCADE',
    });
  };

  return PurchaseReturn;
};
