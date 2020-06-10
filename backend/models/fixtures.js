import {db} from './db.js'
import {Concepto, Turno, Usuario} from "./index.js";

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
        { nombre: "Martin", apellido: "Rados", email: "radosm@gmail.com", password: "12345"},
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