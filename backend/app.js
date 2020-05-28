const express = require('express')
const cors = require('cors')
const app = express()
const bodyParser = require('body-parser');
var morgan = require('morgan')
var https = require('https')
var fs = require('fs')

var model = require('./model');
var auth = require('./auth');
var config = require('./config');

// Middlewares
// ~~~~~~~~~~~
app.use(cors()); // Habilita CORS
app.use(morgan('dev')); // Loggea requests
app.use(bodyParser.json()); // Parsea el body si el content type es json
app.use(express.static('../frontend/build/web')); // Sirve estáticos
app.use(auth.basicAuth)

// APIS
// ~~~~~~~~~~~~~~~

app.post('/usuarios/login', function (req, res) {
  // Login is done in middleware
  res.send('Login exitoso');
})

app.post('/conceptos/', async function (req, res) {
  console.log(req.body);
  model.Concepto.create({
    nombre: req.body.nombre,
    descripcion: req.body.descripcion,
    latitud: req.body.latitud,
    longitud: req.body.longitud,
  }).then((concepto) => res.send(concepto))
    .catch((err) => res.status(400).send(err.message));
});


app.get('/conceptos/:id', async function (req, res) {
  const concepto = await model.Concepto.findOne({
    where : {
      id: req.params.id
    }
  });
  if (!concepto) {
    return res.status(404).send(`Concepto ${req.params.id} no encontrado.`)
  }
  res.send(concepto);
});

app.put('/conceptos/:id', async function (req, res) {

  const concepto = await model.Concepto.findOne({
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
