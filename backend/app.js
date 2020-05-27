const express = require('express')
const cors = require('cors')
const app = express()
const bodyParser = require('body-parser');
var morgan = require('morgan')

var model = require('./model');
var auth = require('./auth');

// Middlewares
// ~~~~~~~~~~~
app.use(cors()); // Habilita CORS
app.use(morgan('dev')); // Loggea requests
app.use(bodyParser.json()); // Parsea el body si el content type es json
app.use(express.static('../frontend/build/web')); // Sirve estáticos
app.use(auth.basicAuth)

// APIS
// ~~~~~~~~~~~~~~~

app.get('/login', function (req, res) {
  // Login is done in middleware
  res.send('Login exitoso');
})

// Corre el server
// ~~~~~~~~~~~~~~~
var puerto = process.argv[2] || 80
app.listen(puerto, function () {
  console.log('Escuchando en puerto ' + puerto)
})
