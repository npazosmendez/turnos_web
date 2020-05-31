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
    pathImagen: {
        type: Sequelize.STRING,
        allowNull: true,
        defaultValue: null,
    },
});

const Turno = db.define('turnos', {
    numero: Sequelize.INTEGER,
});

Usuario.hasMany(Turno, {
    foreignKey: {
        allowNull: false
    }
});
Usuario.hasMany(Concepto, {
    foreignKey: {
        allowNull: false
    }
});
Concepto.hasMany(Turno, {
    foreignKey: {
        allowNull: false
    }
});

db.sync({ force: true })
    .then(() => {
        // Se crean las tablas
        console.log(`Base de datos y tablas creadas.`);
    }).then(() => {
        Usuario.bulkCreate([
            { email: "elver@gmail.com", password: "12345"},
            { email: "robertrush@gmail.com", password: "12345"},
        ]);
        Concepto.bulkCreate([
            { habilitado: false, nombre: "Carnicería", descripcion: "La carnicería de elver", latitud: 10, longitud: 20, usuarioId: 1},
            { habilitado: true, nombre: "Verdulería", descripcion: "La verdulería de elver", latitud: 10, longitud: 20, usuarioId: 1},
            { habilitado: true, nombre: "Zapatería", descripcion: "La zapatería de elver", latitud: 10, longitud: 20, usuarioId: 1},
            { habilitado: false, nombre: "Mercería", descripcion: "La verdulería de robertrush", latitud: 16, longitud: 26, usuarioId: 2},
        ]);
        Turno.bulkCreate([
            { numero: 1, usuarioId: 1, conceptoId: 3}, // Elver para la mercería
        ]);
    });

exports.Usuario = Usuario
exports.Concepto = Concepto
exports.Turno = Turno
