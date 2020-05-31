const express = require('express')
const cors = require('cors')
const app = express()
const bodyParser = require('body-parser');
var morgan = require('morgan')
var https = require('https')
var fs = require('fs')
var multer = require('multer')

var model = require('./model');
var auth = require('./auth');
var config = require('./config');

var upload = multer({ dest: 'imagenes_conceptos/' })

// Middlewares
// ~~~~~~~~~~~
app.use(cors()); // Habilita CORS
app.use(morgan('dev')); // Loggea requests
app.use(bodyParser.json()); // Parsea el body si el content type es json
app.use(express.static('../frontend/build/web')); // Sirve estáticos
app.use(auth.basicAuth)

// APIS
// ~~~~~~~~~~~~~~~

app.get('/usuarios/login', function (req, res) {
  res.send(req.usuario)
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

app.get('/conceptos', async function (req, res) {
  const concepto = await model.Concepto.findAll({
    // TODO: validar la query. Puede resultar en excepciones de la bbdd
    where : req.query
  });
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


app.post('/conceptos/:id/asociar_imagen', upload.single('imagen_concepto'), function (req, res, next) {
  // TODO asociar con los modelos en la BBDD
  console.log(`El usuario ${req.usuario.email} subió la imagen\
  ${req.file.destination}${req.file.filename} para el concepto ${req.params.id}.`);
  return res.status(200);
})

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
