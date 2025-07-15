'use strict';

module.exports = (sequelize, DataTypes) => {
  const Store = sequelize.define('Store', {
    kode: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    nama: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    alamat: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    telepon: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    manager: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    is_aktif: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
    catatan: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  }, {
    tableName: 'stores',
    freezeTableName: true,
  });

  Store.associate = function(models) {
    // Store has many sales
    Store.hasMany(models.Sale, { foreignKey: 'storeId' });
    
    // Store has many sale returns
    Store.hasMany(models.SaleReturn, { foreignKey: 'storeId' });
    
    // Store has many stock gudang toko
    Store.hasMany(models.StockGudangToko, { foreignKey: 'storeId' });
    
    // Store has many stock requests
    Store.hasMany(models.StockRequest, { foreignKey: 'toStoreId' });
    
    // Store has many stock transfers (destination store)
    Store.hasMany(models.StockTransfer, { foreignKey: 'storeId' });
    
    // Store has many users
    Store.hasMany(models.User, { foreignKey: 'storeId' });
  };

  return Store;
}; 