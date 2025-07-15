'use strict';

module.exports = (sequelize, DataTypes) => {
  const Log = sequelize.define('Log', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: true, // System logs might not have a user
      references: {
        model: 'users',
        key: 'id',
      },
    },
    action: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    module: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    level: {
      type: DataTypes.ENUM('info', 'warning', 'error', 'success'),
      defaultValue: 'info',
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    details: {
      type: DataTypes.JSON,
      allowNull: true,
    },
    ipAddress: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    userAgent: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    resourceType: {
      type: DataTypes.STRING,
      allowNull: true, // e.g., 'sale', 'purchase', 'user', etc.
    },
    resourceId: {
      type: DataTypes.INTEGER,
      allowNull: true, // ID of the affected resource
    },
    oldValues: {
      type: DataTypes.JSON,
      allowNull: true, // For update operations
    },
    newValues: {
      type: DataTypes.JSON,
      allowNull: true, // For create/update operations
    },
    sessionId: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  }, {
    tableName: 'logs',
    freezeTableName: true,
    timestamps: true,
  });

  Log.associate = function(models) {
    Log.belongsTo(models.User, {
      foreignKey: 'userId',
      as: 'user',
    });
  };

  return Log;
};