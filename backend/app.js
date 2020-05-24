const express = require('express')
const cors = require('cors')
const app = express()

app.locals.c=0;

app.use(cors())

app.use('/', express.static('../frontend/build/web'));

app.get('/hola', function (req, res) {
  res.send('hello world '+app.locals.c)
  app.locals.c++
  console.log('koko')
})

app.listen(3000)