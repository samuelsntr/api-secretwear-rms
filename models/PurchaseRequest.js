'use strict';
module.exports = (sequelize, DataTypes) => {
  const PurchaseRequest = sequelize.define('PurchaseRequest', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    tanggal: DataTypes.DATEONLY,
    status: {
      type: DataTypes.ENUM('draft', 'diajukan', 'disetujui', 'ditolak'),
      defaultValue: 'draft',
    },
    catatan: DataTypes.TEXT,
    created_by: DataTypes.INTEGER,
    approved_by: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    approved_at: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    rejection_reason: {
      type: DataTypes.TEXT,
      allowNull: true,
    }
  }, {
    tableName: 'purchase_requests',
    freezeTableName: true,
  });

  PurchaseRequest.associate = function(models) {
    PurchaseRequest.hasMany(models.PurchaseRequestItem, {
      foreignKey: 'purchaseRequestId',
      as: 'items',
      onDelete: 'CASCADE',
    });

    PurchaseRequest.belongsTo(models.User, {
      foreignKey: 'created_by',
      as: 'creator',
    });

    PurchaseRequest.belongsTo(models.User, {
      foreignKey: 'approved_by',
      as: 'approver',
    });
  };

  return PurchaseRequest;
};
