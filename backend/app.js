import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import https from 'https';
import fs from 'fs';
import path from 'path';
import multer from 'multer';

import { Concepto, Turno } from "./model.js";
import { basicAuth } from "./auth.js";
import config from './config.js';

const app = express()

// Middlewares
// ~~~~~~~~~~~
app.use(cors()); // Habilita CORS
app.use(morgan('dev')); // Loggea requests
app.use(bodyParser.json()); // Parsea el body si el content type es json
// NOTE: ojo que se sirve todo lo de los directorios
app.use(express.static('../frontend/build/web'));
app.use(express.static('uploads'));
app.use(basicAuth);

// APIS
// ~~~~~~~~~~~~~~~

app.get('/usuarios/login', function (req, res) {
  res.send(req.usuario)
})

app.post('/conceptos/', async function (req, res) {
  Concepto.create({
    nombre: req.body.nombre,
    descripcion: req.body.descripcion,
    latitud: req.body.latitud,
    longitud: req.body.longitud,
  }).then((concepto) => res.send(concepto))
    .catch((err) => res.status(400).send(err.message));
});

app.get('/conceptos', async function (req, res) {
  const concepto = await Concepto.findAll({
    // TODO: validar la query. Puede resultar en excepciones de la bbdd
    where : req.query
  });
  res.send(concepto);
});

app.put('/conceptos/:id', async function (req, res) {

  const concepto = await Concepto.findOne({
    where : {
      id: req.params.id
    }
  });
  if (!concepto) {
    return res.status(404).send("No encontré ese concepto, gil.");
  }
  concepto.habilitado = req.body.habilitado;
  concepto.save().then(concepto => {
    return res.status(200).send(concepto);
  }).catch((err) => {
    console.log(err)
    return res.status(400).send(err.message);
  });
});

app.post(
  '/conceptos/:id/asociar_imagen',
  multer({ dest: 'uploads/imagenes_conceptos' }).single('imagen_concepto'),
  async function (req, res, next) {
    const concepto = await Concepto.findOne({
      where : {
        id: req.params.id
      }
    });
    if (!concepto) {
      return res.status(404).send("No encontré ese concepto, gil.");
    }
    concepto.pathImagen = path.join("imagenes_conceptos", req.file.filename);
    concepto.save().then(concepto => {
      return res.status(200).send(concepto);
    }).catch((err) => {
      console.log(err)
      return res.status(400).send(err.message);
    });
  }
);

app.get('/conceptos/:id/turnos', async function (req, res) {
  const turnos = await Turno.findAll({
    where : { conceptoId: req.params.id }
  });
  res.send(turnos);
});

app.post('/conceptos/:id/turnos', async function (req, res) {
  Turno.create({
    usuarioId: req.usuario.id,
    conceptoId: req.params.id
  }).then((turno) => res.send(turno))
    .catch((err) => res.status(500).send(err.message));
});

// Corre el server
// ~~~~~~~~~~~~~~~
let server;
if (config.https) {
  server = https.createServer({
    key: fs.readFileSync(config.ssl_private),
    cert: fs.readFileSync(config.ssl_cert)
  }, app)
} else {
  server = app;
}
server.listen(config.port, function () {
  console.log('Escuchando en puerto ' + config.port)
})
