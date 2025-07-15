'use strict';

module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    username: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    role: {
      type: DataTypes.ENUM('admin', 'staff_gudang', 'staff_sales', 'owner'),
      allowNull: false,
    },
    storeId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'stores',
        key: 'id',
      },
    },
  },
  {
    tableName: "users",
    freezeTableName: true,
  });

  User.associate = function(models) {
    User.belongsTo(models.Store, { foreignKey: 'storeId' });
  };

  return User;
};
