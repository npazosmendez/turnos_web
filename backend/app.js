import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import https from 'https';
import fs from 'fs';
import path from 'path';
import multer from 'multer';

import { Concepto, Turno, Usuario } from "./model.js";
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
app.use((req, res, next) => {
  res.set('Cache-Control', 'no-store'); // Deshabilita el caché
  next();
})

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
  // TODO/NOTE: el create parece devolver el objeto con los fields de los mismos tipos que
  // se pusieron en .create(...), todavía sin haber sido casteados por el engine.
  // Es decir, si pongo longitud: "12" el create me devuelve un concepto con longitud de tipo string.
  // Si hago el find posterior, ya es double. Habría que investigar, por el momento solo tengo cuidado
  // de mandar los tipos correctos en el post.
  Concepto.create({
    nombre: req.body.nombre,
    descripcion: req.body.descripcion,
    latitud: req.body.latitud,
    longitud: req.body.longitud,
    usuarioId: req.usuario.id
  }).then((concepto) => res.send(concepto))
    .catch((err) => res.status(400).send(err.message));
});

app.get('/conceptos', async function (req, res) {
  let conceptos = await Concepto.findAll({
    // TODO: validar la query. Puede resultar en excepciones de la bbdd
    where : req.query,
  });

  conceptos = conceptos.map(c => c.get({plain: true}));
  for(var c of conceptos) {
    // NOTE: acá podemos enriquecer las instancias con info adicional antes de mandarlas.
    // La forma más linda sería usar getters/setter de sequalize o los llamados "fields virtuales",
    // pero no los soporta asincrónicos :(
    c.enFila = await Concepto.enFila(c.id);
  }

  res.json(conceptos);
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
  function (req, res, next) {
    if(req.concepto.pathImagen) {
      // TODO: io sincrónico
      fs.unlinkSync(path.join("uploads", req.concepto.pathImagen));
    }
    req.concepto.pathImagen = path.join("imagenes_conceptos", req.file.filename);
    next();
  },
  saveAndSendConcepto
);

app.get('/turnos', async function (req, res) {
  let  filtros = {}
  if (req.query.conceptoId) {
    filtros.conceptoId = req.query.conceptoId;
  }
  if (req.query.usuarioId) {
    filtros.usuarioId = req.query.usuarioId;
  }
  const turnos = await Turno.findAll({
    where : filtros,
    include: [{ model: Concepto }, { model: Usuario }]
  });
  res.send(turnos);
});

app.post('/turnos', async function (req, res) {
  // TODO: error handling (o mejor enchufarlo en el pipeline de obtenerConcepto)
  var concepto = await Concepto.findOne({
    where: {
      id: req.body.conceptoId
    }
  });
  if (await concepto.filaLlena()) {
    return res.status(400).send("La fila está llena.");
  }
  Turno.create({
    usuarioId: req.usuario.id,
    conceptoId: parseInt(req.body.conceptoId)
  }).then((turno) => res.send(turno))
    .catch((err) => res.status(500).send(err.message));
});

app.get('/turnos/:turnoId/personas_adelante', async function (req, res, next) {
  try {
    const turno = await Turno.findByPk(req.params.turnoId);
    const result = await turno.personas_adelante();
    res.send(result.toString());
  } catch (err) {
    next(err);
  }
});

// Error handling global
/* NOTE: los errores de promises no manejados no llegan acá.
Puede eso puede hacerse dentro del middleware:
  promise.catch(next)
*/
app.use(function (err, req, res, next) {
  console.error("ERROR: " + err);
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
