'use strict';

module.exports = (sequelize, DataTypes) => {
  const StockGudangPusat = sequelize.define('StockGudangPusat', {
    barangId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'barangs',
        key: 'id',
      },
    },
    stok: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },
    maximum_stock: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Maximum stock level for this product in central warehouse',
    },
    minimum_stock: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Minimum stock level before reorder alert for central warehouse',
    },
  }, {
    tableName: 'stock_gudang_pusat',
    freezeTableName: true,
  });

  StockGudangPusat.associate = function(models) {
    StockGudangPusat.belongsTo(models.Barang, { foreignKey: 'barangId' });
  };

  return StockGudangPusat;
}; 