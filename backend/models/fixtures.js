import {db} from './db.js'
import {Concepto, Turno, Usuario} from "./index.js";

db.sync({ force: true })
  .then(async () => {
    // Se crearon las tablas
    console.log(`Base de datos y tablas creadas.`);
    try {

      // Elver y sus conceptos
      const elver = await Usuario.create({ nombre: "Elver", apellido: "Sero", email: "elver@gmail.com", password: "123456"});
      await Concepto.bulkCreate([
        {
          habilitado: true,
          nombre: "La verdulería de Elver",
          descripcion: "Tomates perita 2Kg x $250",
          latitud: -34.6168142,
          longitud: -58.3727203,
          usuarioId: elver.id,
        },
        {
          habilitado: true,
          nombre: "La zapatería del Elver",
          descripcion: "Lleve dos zapatos al precio de uno.",
          latitud: -34.6176142,
          longitud: -58.3721203,
          usuarioId: elver.id,
        },
        {
          habilitado: false,
          nombre: "La mercería de Elver",
          descripcion: "Entraron agujas de crochet no. 9.",
          latitud: -34.6176142,
          longitud: -58.3621203,
          usuarioId: elver.id,
        },
      ]);

      // José Monopolio y sus monopolios
      const jose = await Usuario.create({ nombre: "José", apellido: "Monopolio", email: "jose@gmail.com", password: "123456"});
      await Concepto.bulkCreate([
        {
          habilitado: false,
          nombre: "McDonald's",
          descripcion: "¡Me encanta!",
          latitud: -34.6058142,
          longitud: -58.3919203,
          usuarioId: jose.id,
          maximaEspera: 15,
        },
        {
          habilitado: true,
          nombre: "Starbucks",
          descripcion: "El mejor café",
          latitud: -34.6032899,
          longitud: -58.4130282,
          usuarioId: jose.id,
        },
        {
          habilitado: true,
          nombre: "Farmacity",
          descripcion: "Ibuprofeno, pañales, leche, destornilladores, todo lo que necesitás.",
          latitud: -34.5883421,
          longitud: -58.4886747,
          usuarioId: jose.id,
        },
        {
          habilitado: true,
          nombre: "Coto",
          descripcion: "¡Yo te conozco!",
          latitud: -34.6194593,
          longitud: -58.4766261,
          usuarioId: jose.id,
        },
      ]);

      // Donald y sus conceptos
      const asmid = await Usuario.create({ nombre: "Donald", apellido: "Trump", email: "donald@gmail.com", password: "123456"});
      await Concepto.bulkCreate([
        {
          habilitado: true,
          nombre: "Telas vendo",
          descripcion: "Las mejores telas de todo Once.",
          latitud: -34.6050228,
          longitud: -58.4070207,
          usuarioId: asmid.id,
        },
        {
          habilitado: true,
          nombre: "Burgio",
          descripcion: "La mejor pizza de Buenos Aires.",
          latitud: -34.5601519,
          longitud: -58.4631785,
          usuarioId: asmid.id,
        },
        {
          habilitado: true,
          nombre: "Patagonia",
          descripcion: "Cerveza de la Patagonia.",
          latitud: -34.5832419,
          longitud: -58.4857741,
          usuarioId: asmid.id,
        },
      ]);

      // Rober y su puesto de bondiola
      const rober = await Usuario.create({ nombre: "Roberto", apellido: "Rushero", email: "robertrush@gmail.com", password: "123456"});
      await Concepto.bulkCreate([
        {
          habilitado: true,
          nombre: "El rey de la bondiola",
          descripcion: "Ahora bondiola light con coca zero.",
          latitud: -34.5555884,
          longitud: -58.4241203,
          usuarioId: rober.id,
        },
      ]);

      // Algunos clientes
      var tomas = await Usuario.create({ nombre: "Tomás", apellido: "Fanta", email: "tomas@gmail.com", password: "123456"});
      var armando = await Usuario.create({ nombre: "Armando", apellido: "Paredes", email: "armando@gmail.com", password: "123456"});
      var sol = await Usuario.create({ nombre: "Sol", apellido: "Pérez", email: "sol@gmail.com", password: "123456"});
      var martin = await Usuario.create({ nombre: "Martin", apellido: "Rados", email: "radosm@gmail.com", password: "123456"});

      var zapateria = await Concepto.findOne({ where: {nombre: "La zapatería del Elver"} });
      await Turno.create({conceptoId: zapateria.id, usuarioId: tomas.id});
      await Turno.create({conceptoId: zapateria.id, usuarioId: armando.id});
      await Turno.create({conceptoId: zapateria.id, usuarioId: sol.id});
      await Turno.create({conceptoId: zapateria.id, usuarioId: martin.id});

    } catch (err) {
      console.error("ERROR poblando las tablas:", err)
    }
  })
  .catch((err) => console.log("ERROR creando las tablas:", err));