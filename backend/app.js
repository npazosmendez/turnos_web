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
import nodeMailer from 'nodemailer';

const app = express();

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

app.get('/send-email', function (req, res) {
  let transporter = nodeMailer.createTransport({
      host: 'smtp.gmail.com',
      port: 465,
      secure: true,
      auth: {
          // should be replaced with real sender's account
          user: 'turnoslocos@gmail.com',
          pass: 'tparqweb'
      }
  });
  let mailOptions = {
      // should be replaced with real recipient's account
      to: 'radosm@gmail.com',
      subject: 'Prueba desde node', //req.body.subject,
      text: 'Hola!' //req.body.message
  };
  transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
          return console.log(error);
      }
      console.log('Message %s sent: %s', info.messageId, info.response);
  });
  res.status(200);
  res.end();
});

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

async function obtenerConcepto(req, res, next) {
  Concepto.findOne({
    where : {
      id: req.params.id
    }
  })
    .then((concepto) => {
      if (!concepto) {
        return res.status(404).send("No encontré ese concepto, gil.");
      } else {
        req.concepto = concepto;
        next();
      }
    })
    .catch(next);
}

// No se me ocurrió un nombre bello en español
async function saveAndSendConcepto(req, res, next) {
  req.concepto.save().then(concepto => {
    return res.status(200).send(concepto);
  }).catch(next);
}

app.put(
  '/conceptos/:id',
  obtenerConcepto,
  async function (req, res, next) {
    req.concepto.habilitado = req.body.habilitado;
    next();
  },
  saveAndSendConcepto
);

app.post(
  '/conceptos/:id/asociar_imagen',
  obtenerConcepto,
  multer({ dest: 'uploads/imagenes_conceptos' }).single('imagen_concepto'),
  async function (req, res, next) {
    req.concepto.pathImagen = path.join("imagenes_conceptos", req.file.filename);
    next();
  },
  saveAndSendConcepto
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

// Error handling global
/* NOTE: los errores de promises no manejados no llegan acá.
Puede eso puede hacerse dentro del middleware:
  promise.catch(next)
*/
app.use(function (err, req, res, next) {
  console.error("ERROR: " + ex);
  res.status(500).send(err.message);
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
