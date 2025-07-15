'use strict';

module.exports = (sequelize, DataTypes) => {
  const StockTransferItem = sequelize.define('StockTransferItem', {
    stockTransferId: {
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
    tableName: 'stock_transfer_items',
    freezeTableName: true,
  });

  StockTransferItem.associate = function(models) {
    StockTransferItem.belongsTo(models.StockTransfer, {
      foreignKey: 'stockTransferId',
      onDelete: 'CASCADE',
    });
    StockTransferItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return StockTransferItem;
}; 