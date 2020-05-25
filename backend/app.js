const express = require('express')
const cors = require('cors')
const app = express()
const bodyParser = require('body-parser');
var morgan = require('morgan')

var model = require('./model');

app.locals.c = 0;

// Middlewares
// ~~~~~~~~~~~
app.use(cors()); // Habilita CORS
app.use(morgan('dev')); // Loggea requests
app.use(bodyParser.json()); // Parsea el body si el content type es json
app.use(express.static('../frontend/build/web')); // Sirve estáticos


// API REST
// ~~~~~~~~
app.get('/propietarios/:dni', function (req, res) {
  model.Propietario.findAll(
    {
      where: {
        dni: req.params.dni
      }
    }).then(propietarios => res.json(propietarios));
});

app.post('/propietarios', function (req, res) {
  console.log(req.body.nombre)
  model.Propietario.create({
      nombre: req.body.nombre,
      edad: req.body.edad,
      dni: req.body.dni
    }).then((propietario) => {res.json(propietario)});
});

app.get('/hola', function (req, res) {
  res.send('hello world ' + app.locals.c)
  app.locals.c++
  console.log('koko')
})


// Corre el server
// ~~~~~~~~~~~~~~~
var puerto = process.argv[2] || 80
app.listen(puerto, function () {
  console.log('Escuchando en puerto ' + puerto)
})
