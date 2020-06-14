import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import https from 'https';
import fs from 'fs';
import compression from 'compression';

import { noCacheMiddleware, errorHandlingMiddleware } from "./middlewares/common.js";
import { basicAuthMiddleware } from "./middlewares/auth.js";

import config from './config.js';

import usuarios from "./api/usuarios.js";
import conceptos from "./api/conceptos.js";
import turnos from "./api/turnos.js";


const app = express();
// Middlewares
// ~~~~~~~~~~~
app.use(cors()); // Habilita CORS
app.use(morgan('dev')); // Loggea requests
app.use(bodyParser.json()); // Parsea el body si el content type es json
app.use(compression()) // Comprime los requests, los estáticos de flutter son enormes
app.use('/tmp',express.static('tmp')); // NOTE: ojo que se sirve todo lo de los directorios
app.use(express.static('static'));
app.use(express.static('uploads'));
app.use(basicAuthMiddleware);
app.use(noCacheMiddleware)

// APIS
// ~~~~~~~~~~~~~~~
app.use('/usuarios', usuarios);
app.use('/conceptos', conceptos);
app.use('/turnos', turnos);

// Error handling global
/* NOTE: los errores de promises no manejados no llegan acá.
Puede eso puede hacerse dentro del middleware: promise.catch(next)
*/
app.use(errorHandlingMiddleware);

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
