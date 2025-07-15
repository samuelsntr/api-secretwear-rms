'use strict';

module.exports = (sequelize, DataTypes) => {
  const StockRequest = sequelize.define('StockRequest', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    fromWarehouse: {
      type: DataTypes.STRING, // e.g., 'gudang_pusat'
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM('pending', 'approved', 'rejected', 'fulfilled'),
      defaultValue: 'pending',
    },
    toStoreId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'stores',
        key: 'id',
      },
    },
  }, {
    tableName: 'stock_requests',
    freezeTableName: true,
  });

  StockRequest.associate = function(models) {
    StockRequest.hasMany(models.StockRequestItem, {
      foreignKey: 'stockRequestId',
      as: 'items',
      onDelete: 'CASCADE',
    });
    StockRequest.belongsTo(models.Store, { foreignKey: 'toStoreId', as: 'toStore' });
  };

  return StockRequest;
}; 