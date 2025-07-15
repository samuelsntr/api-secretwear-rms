'use strict';

module.exports = (sequelize, DataTypes) => {
  const SaleItem = sequelize.define('SaleItem', {
    saleId: DataTypes.INTEGER,
    barangId: DataTypes.INTEGER,
    qty: DataTypes.INTEGER,
    harga: DataTypes.DECIMAL(15, 2),
    subtotal: DataTypes.DECIMAL(15, 2),
    discount_percent: {
      type: DataTypes.FLOAT,
      allowNull: false,
      defaultValue: 0,
    },
  }, {
    tableName: 'sale_items',
    freezeTableName: true,
  });

  SaleItem.associate = function (models) {
    SaleItem.belongsTo(models.Sale, {
      foreignKey: 'saleId',
      onDelete: 'CASCADE',
    });
    SaleItem.belongsTo(models.Barang, {
      foreignKey: 'barangId',
    });
  };

  return SaleItem;
};
