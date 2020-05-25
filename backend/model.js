const Sequelize = require('sequelize');
const sequelize = new Sequelize("sqlite::memory:", {
    logging: false,
});


const Propietario = sequelize.define('propietario', {
    nombre: Sequelize.TEXT,
    edad: Sequelize.INTEGER,
    dni: Sequelize.INTEGER
});


sequelize.sync({ force: true })
    .then(() => {
        // Se crean las tablas
        console.log(`Base de datos y tablas creadas.`);
    }).then(() =>
        // Poblamos las tablas
        Propietario.bulkCreate([
            { nombre: "Alberto", edad: 61, dni: 13900587 },
            { nombre: "Elver", edad: 21, dni: 38383838 },
        ])
    );

exports.Propietario = Propietario