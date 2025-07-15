'use strict';

module.exports = (sequelize, DataTypes) => {
  const Ukuran = sequelize.define('Ukuran', {
    nama: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  }, {
    tableName: 'ukurans',
    freezeTableName: true,
  });

  Ukuran.associate = function(models) {
    Ukuran.hasMany(models.Barang, { foreignKey: 'ukuranId' });
  };

  return Ukuran;
};
