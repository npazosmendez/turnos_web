import Sequelize from 'sequelize';

export const db = new Sequelize("sqlite::memory:", {
  logging: false,
});