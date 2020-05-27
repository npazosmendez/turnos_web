const Sequelize = require('sequelize');
const db = new Sequelize("sqlite::memory:", {
    logging: false,
});

const Usuario = db.define('usuarios', {
    email: Sequelize.TEXT,
    password: Sequelize.TEXT
});

const Concepto = db.define('conceptos', {
    nombre: Sequelize.TEXT,
    descripcion: Sequelize.TEXT,
    latitud: Sequelize.FLOAT,
    longitud: Sequelize.FLOAT,
});

const Turno = db.define('turnos', {
    numero: Sequelize.INTEGER,
});

Usuario.hasMany(Turno);
Concepto.hasMany(Turno);

db.sync({ force: true })
    .then(() => {
        // Se crean las tablas
        console.log(`Base de datos y tablas creadas.`);
    }).then(() => {
        Usuario.bulkCreate([
            { email: "elver@gmail.com", password: "12345"},
            { email: "robertrush@gmail.com", password: "12345"},
        ]);
    });

exports.Usuario = Usuario
