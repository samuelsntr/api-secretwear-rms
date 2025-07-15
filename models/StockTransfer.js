'use strict';

module.exports = (sequelize, DataTypes) => {
  const StockTransfer = sequelize.define('StockTransfer', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    stockRequestId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    storeId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'stores',
        key: 'id',
      },
    },
    status: {
      type: DataTypes.ENUM('pending', 'completed'),
      defaultValue: 'pending',
    },
  }, {
    tableName: 'stock_transfers',
    freezeTableName: true,
  });

  StockTransfer.associate = function(models) {
    StockTransfer.belongsTo(models.StockRequest, {
      foreignKey: 'stockRequestId',
    });
    StockTransfer.belongsTo(models.Store, {
      foreignKey: 'storeId',
      as: 'toStore',
    });
    StockTransfer.hasMany(models.StockTransferItem, {
      foreignKey: 'stockTransferId',
      as: 'items',
      onDelete: 'CASCADE',
    });
  };

  return StockTransfer;
}; 