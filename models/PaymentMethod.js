'use strict';

module.exports = (sequelize, DataTypes) => {
  const PaymentMethod = sequelize.define('PaymentMethod', {
    nama: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    deskripsi: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    is_aktif: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  }, {
    tableName: 'payment_methods',
    freezeTableName: true,
  });

  PaymentMethod.associate = function (models) {
    PaymentMethod.hasMany(models.Sale, {
      foreignKey: 'paymentMethodId',
      as: 'sales',
    });
    PaymentMethod.hasMany(models.SaleReturn, {
      foreignKey: 'refundMethodId',
      as: 'saleReturns',
    });
  };

  return PaymentMethod;
}; 