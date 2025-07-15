'use strict';

module.exports = (sequelize, DataTypes) => {
  const Warna = sequelize.define('Warna', {
    nama: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  }, {
    tableName: 'warnas',
    freezeTableName: true,
  });

  Warna.associate = function(models) {
    Warna.hasMany(models.Barang, { foreignKey: 'warnaId' });
  };

  return Warna;
};
