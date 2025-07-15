'use strict';

module.exports = (sequelize, DataTypes) => {
  const Barang = sequelize.define('Barang', {
    nama: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    sku: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false,
    },
    barcode: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    kategoriId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'kategoris',
        key: 'id',
      },
      allowNull: false,
    },
    warnaId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'warnas',
        key: 'id',
      },
      allowNull: true,
    },
    ukuranId: {
      type: DataTypes.INTEGER,
      references: {
        model: 'ukurans',
        key: 'id',
      },
      allowNull: true,
    },
    stok: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      allowNull: false,
    },
    harga_beli: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
    },
    harga_jual: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
    },
    gambar: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    deskripsi: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    is_aktif: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
  }, {
    tableName: 'barangs',
    freezeTableName: true,
  });

  Barang.associate = function(models) {
    Barang.belongsTo(models.Kategori, { foreignKey: 'kategoriId' });
    Barang.belongsTo(models.Warna, { foreignKey: 'warnaId' });
    Barang.belongsTo(models.Ukuran, { foreignKey: 'ukuranId' });
  };

  return Barang;
};
