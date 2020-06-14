import express from 'express';
import {Usuario} from "../models/index.js";

let router = express.Router();
router.get('/login', login);
router.post('/', create_user);

function login(req, res) {
  // User login handled in middleware
  res.send(req.usuario)
}

async function create_user(req, res) {
  let user_data = {
    email: req.body.email,
    password: req.body.password,
    nombre: req.body.nombre,
    apellido: req.body.apellido
  }
  Usuario.create(user_data).then((usuario) => res.status(201).send(usuario))
    .catch((err) => {
      res.status(400).send(err.errors.length > 0 ? err.errors[0].message : err.message);
    });
}

export default router;