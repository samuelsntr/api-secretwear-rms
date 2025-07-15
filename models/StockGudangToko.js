'use strict';

module.exports = (sequelize, DataTypes) => {
  const StockGudangToko = sequelize.define('StockGudangToko', {
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
    storeId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  }, {
    tableName: 'stock_gudang_toko',
    freezeTableName: true,
  });

  StockGudangToko.associate = function(models) {
    StockGudangToko.belongsTo(models.Barang, { foreignKey: 'barangId' });
    StockGudangToko.belongsTo(models.Store, { foreignKey: 'storeId' });
  };

  return StockGudangToko;
};