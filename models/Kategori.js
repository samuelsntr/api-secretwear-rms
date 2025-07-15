'use strict';

module.exports = (sequelize, DataTypes) => {
  const Kategori = sequelize.define('Kategori', {
    nama: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  }, {
    tableName: 'kategoris',
    freezeTableName: true,
  });

  Kategori.associate = function(models) {
    Kategori.hasMany(models.Barang, { foreignKey: 'kategoriId' });
  };

  return Kategori;
};
