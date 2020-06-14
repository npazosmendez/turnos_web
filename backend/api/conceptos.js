import express from 'express';
import {Concepto} from "../models/index.js";
import multer from "multer";
import fs from "fs";
import path from "path";
import mailer from "../TurnosMailer.js";

class ConceptosApi {
  constructor() {
    this.router = express.Router();
    this.router.post('/', ConceptosApi.create);
    this.router.get('/', ConceptosApi.query);
    this.router.put('/:id', ConceptosApi.getConceptoOr404, ConceptosApi.update);
    this.router.put('/:id/atender_siguiente', ConceptosApi.getConceptoOr404, ConceptosApi.atender_siguiente);
    this.router.post('/:id/asociar_imagen',
      ConceptosApi.getConceptoOr404,
      multer({ dest: 'uploads/imagenes_conceptos' }).single('imagen_concepto'),
      ConceptosApi.uploadImagen
    );
  }

  static async create(req, res) {
    Concepto.create({
      nombre: req.body.nombre,
      descripcion: req.body.descripcion,
      latitud: req.body.latitud,
      longitud: req.body.longitud,
      usuarioId: req.usuario.id
    }).then((concepto) => res.send(concepto))
      .catch((err) => res.status(400).send(err.message));
  }

  static async query(req, res) {
    let conceptos = await Concepto.findAll({ where : req.query });
    conceptos = await Promise.all(conceptos.map(ConceptosApi._serialize_concepto));
    res.json(conceptos);
  }

  static async update (req, res) {
    req.concepto.habilitado = req.body.habilitado;
    const concepto = await req.concepto.save();
    return res.status(200).send(concepto);
  }

  static async uploadImagen(req, res) {
    if(req.concepto.pathImagen) {
      // TODO: io sincrónico
      fs.unlinkSync(path.join("uploads", req.concepto.pathImagen));
    }
    req.concepto.pathImagen = path.join("imagenes_conceptos", req.file.filename);
    const concepto = await req.concepto.save();
    return res.status(200).send(concepto);
  }

  static async atender_siguiente(req, res, next) {
    // TODO: agregar alguna validación, como pedir el uuid del turno en el request
    let turno = await req.concepto.siguiente();
    if(!turno) {
      return res.status(400).send("No hay clientes esperando.");
    }
    try {
      await turno.destroy();
    } catch (err) {
      next(err);
    }
    mailer.notificar_proximo_en_fila_para(req.concepto);

    return res.status(200).send();
  }

  static async getConceptoOr404(req, res, next) {
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

  static async _serialize_concepto(concepto) {
    let serialized = concepto.get({plain: true});
    serialized.enFila = await Concepto.enFila(concepto.id);
    return serialized;
  }
}

const router = new ConceptosApi().router;
export default router;