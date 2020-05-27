const Sequelize = require('sequelize');
const db = new Sequelize("sqlite::memory:", {
    logging: false,
});

const Usuario = db.define('usuarios', {
    email: Sequelize.TEXT,
    password: Sequelize.TEXT
});

const Concepto = db.define('conceptos', {
    habilitado: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true
    },
    nombre: {
        type: Sequelize.STRING,
        allowNull: false,
        len: [3,50]
    },
    descripcion: {
        type: Sequelize.STRING,
        allowNull: false,
        len: [3,50]
    },
    latitud: {
        type: Sequelize.FLOAT,
        allowNull: false
    },
    longitud: {
        type: Sequelize.FLOAT,
        allowNull: false
    },
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
exports.Concepto = Concepto
exports.Turno = Turno
