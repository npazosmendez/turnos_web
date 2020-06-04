import Sequelize from 'sequelize';
import { v4 as uuidv4 } from 'uuid'; // v4=random uuid

const db = new Sequelize("sqlite::memory:", {
    logging: false,
});

export const Usuario = db.define('usuarios', {
    email: Sequelize.TEXT,
    password: Sequelize.TEXT
});

export class Concepto extends Sequelize.Model {

    // No me sirve como método de instancia porque se usa para plain objects
    static async enFila(conceptoId) {
        return Turno.count({
            where : {
                conceptoId: conceptoId,
            }
        });
    }

    async filaLlena() {
        return this.maximaEspera && this.maximaEspera <= await Concepto.enFila(this.id);
    }

}

Concepto.init({
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
    maximaEspera: {
        type: Sequelize.INTEGER,
        allowNull: true,
        defaultValue: null,
    },
}, {
  sequelize: db,
  modelName: "concepto",
});

export class Turno extends Sequelize.Model {
    static async proximo_numero(conceptoId) {
        const maximo = await this.max("numero", { where: { conceptoId: conceptoId }});
        return isNaN(maximo) ? 1 : maximo + 1;
    }

    static async create({conceptoId, usuarioId}, options) {
        return super.create({
          conceptoId: conceptoId,
          usuarioId: usuarioId,
          numero: await this.proximo_numero(conceptoId),
          uuid: uuidv4()
        }, options);
    }
}

Turno.init({
      numero: Sequelize.INTEGER,
      uuid: Sequelize.CHAR,
  }, {
    sequelize: db,
    modelName: "turno",
});


Usuario.hasMany(Turno, {
    foreignKey: {
        allowNull: false
    }
});
Turno.belongsTo(Usuario);

Usuario.hasMany(Concepto, {
    foreignKey: {
        allowNull: false
    }
});
Concepto.belongsTo(Usuario);

Concepto.hasMany(Turno, {
    foreignKey: {
        allowNull: false
    }
});
Turno.belongsTo(Concepto);

db.sync({ force: true })
    .then(async () => {
        // Se crearon las tablas
        console.log(`Base de datos y tablas creadas.`);
        try {
            await Usuario.bulkCreate([
                { email: "elver@gmail.com", password: "12345"},
                { email: "robertrush@gmail.com", password: "12345"},
            ]);
            await Concepto.bulkCreate([
                {
                    habilitado: false,
                    nombre: "Carnicería",
                    descripcion: "La carnicería de elver",
                    latitud: 10,
                    longitud: 20,
                    usuarioId: 1,
                    maximaEspera: 1,
                },
                {
                    habilitado: true,
                    nombre: "Verdulería",
                    descripcion: "La verdulería de elver",
                    latitud: 10,
                    longitud: 20,
                    usuarioId: 1,
                },
                {
                    habilitado: true,
                    nombre: "Zapatería",
                    descripcion: "La zapatería de elver",
                    latitud: 10,
                    longitud: 20,
                    usuarioId: 1,
                },
                {
                    habilitado: false,
                    nombre: "Mercería",
                    descripcion: "La verdulería de robertrush",
                    latitud: 16,
                    longitud: "26",
                    usuarioId: 2,
                },
            ]);
            await Turno.bulkCreate([
                { numero: 1, usuarioId: 1, conceptoId: 3, uuid: uuidv4()}, // Elver para la mercería
            ]);
        } catch (err) {
            console.error("ERROR poblando las tablas:", err)
        }
    })
    .catch((err) => console.log("ERROR creando las tablas:", err));