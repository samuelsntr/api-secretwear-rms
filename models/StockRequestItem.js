'use strict';

module.exports = (sequelize, DataTypes) => {
  const StockRequestItem = sequelize.define('StockRequestItem', {
    stockRequestId: {
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
  }, {
    tableName: 'stock_request_items',
    freezeTableName: true,
  });

  StockRequestItem.associate = function(models) {
    StockRequestItem.belongsTo(models.StockRequest, {
      foreignKey: 'stockRequestId',
      onDelete: 'CASCADE',
    });
    StockRequestItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return StockRequestItem;
}; 