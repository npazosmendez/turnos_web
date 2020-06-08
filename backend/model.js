import Sequelize from 'sequelize';
import { v4 as uuidv4 } from 'uuid'; // v4=random uuid

const db = new Sequelize("sqlite::memory:", {
    logging: false,
});

export const Usuario = db.define('usuarios', {
    email: {
        type: Sequelize.TEXT,
        allowNull: false,
    },
    password: {
        type: Sequelize.TEXT,
        allowNull: false,
    },
    nombre: {
        type: Sequelize.TEXT,
        allowNull: false,
    },
    apellido: {
        type: Sequelize.TEXT,
        allowNull: false,
    },
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

    async siguiente(include_usuario=false) {
        // include_usuario indica si la respuesta contiene el usuario asociado o no

        const siguiente_numero = await Turno.min("numero", {
            where: { conceptoId: this.id}
        });
        if (isNaN(siguiente_numero)) {
            return null;
        }

        let included_related_models = [];
        if (include_usuario) {
            included_related_models.push({ model: Usuario });
        }
        return Turno.findOne({
            where: {
                conceptoId: this.id,
                numero: siguiente_numero,
            },
            include: included_related_models
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

    async personas_adelante() {
        return Turno.count({
            where: {
                conceptoId: this.conceptoId,
                numero: {
                    [Sequelize.Op.lt]: this.numero
                }
            }
        });
    }

    async turno_de_atras() {
        const numero_de_atras = await Turno.min("numero", {
            where : {
              conceptoId: this.conceptoId,
              numero: {
                [Sequelize.Op.gt]: this.numero
              }
            }
        });
        if (isNaN(numero_de_atras)) {
            return null;
        }
        return Turno.findOne({
            where: {
                conceptoId: this.conceptoId,
                numero: numero_de_atras,
            },
        });

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
                { nombre: "Elver", apellido: "Sero", email: "elver@gmail.com", password: "12345"},
                { nombre: "Roberto", apellido: "Rushero", email: "robertrush@gmail.com", password: "12345"},
                { nombre: "Tomás", apellido: "Fanta", email: "tomasfanta@gmail.com", password: "12345"},
                { nombre: "Armando", apellido: "Paredes", email: "armandoparedes@gmail.com", password: "12345"},
                { nombre: "Sol", apellido: "Pérez", email: "lasobrideperez@gmail.com", password: "12345"},
                { nombre: "Juan", apellido: "Lanuza", email: "juan.lanuza3@gmail.com", password: "12345"},
                { nombre: "Juan", apellido: "Lanu", email: "juanlanu@hotmail.com", password: "12345"},
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
            await Turno.create({conceptoId: 3, usuarioId: 1}); // Elver para la zapatería
            await Turno.create({conceptoId: 3, usuarioId: 2}); // Rober para la zapatería
            await Turno.create({conceptoId: 3, usuarioId: 3}); // Tomás para la zapatería
            await Turno.create({conceptoId: 3, usuarioId: 4}); // Armando para la zapatería
            await Turno.create({conceptoId: 3, usuarioId: 5}); // Sol para la zapatería
        } catch (err) {
            console.error("ERROR poblando las tablas:", err)
        }
    })
    .catch((err) => console.log("ERROR creando las tablas:", err));