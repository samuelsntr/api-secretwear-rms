'use strict';

module.exports = (sequelize, DataTypes) => {
  const Supplier = sequelize.define('Supplier', {
    nama: {
      type: DataTypes.STRING,
      allowNull: false,  // Kolom ini tidak boleh kosong
    },
    kontak: {
      type: DataTypes.STRING,
      allowNull: false,  // Kolom ini tidak boleh kosong
    },
    alamat: {
      type: DataTypes.TEXT,
      allowNull: true,  // Kolom ini boleh kosong
    }
  },
  {
    tableName: "suppliers",
    freezeTableName: true,
  }
  );

  // Relasi dengan model lain bisa didefinisikan di sini
  Supplier.associate = function(models) {
    // Misalnya jika ada relasi dengan model Pembelian:
    // Supplier.hasMany(models.Pembelian, { foreignKey: 'supplierId' });
  };

  return Supplier;
};
