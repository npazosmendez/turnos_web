import express from 'express';
import {Concepto} from "../models/index.js";
import multer from "multer";
import fs from "fs";
import path from "path";
import mailer from "../TurnosMailer.js";
import {basicAuthMiddleware} from "../middlewares/auth.js";
import {cos, asin, sqrt} from 'mathjs';

class ConceptosApi {
  constructor() {
    this.router = express.Router();
    this.router.use(basicAuthMiddleware);
    this.router.post('/', ConceptosApi.create);
    this.router.get('/', ConceptosApi.query);
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
      maximaEspera: req.body.maximaEspera,
      latitud: req.body.latitud,
      longitud: req.body.longitud,
      usuarioId: req.usuario.id
    }).then((concepto) => res.send(concepto))
      .catch((err) => res.status(400).send(err.message));
  }

  static async query(req, res, next) {
    let nearbyConceptsQueryKeys = ['latitud', 'longitud', 'radio'];
    let isNearbyConceptsQuery = nearbyConceptsQueryKeys.every(key => Object.keys(req.query).includes(key));

    try {
      if (isNearbyConceptsQuery){
        console.log("Handling nearby concepts query");
        await ConceptosApi._nearbyQuery(req, res);
      } else {
        console.log("Handling regular concepts query");
        await ConceptosApi._query(req, res);
      }
    } catch (err) {
        next(err);
    }
  }

  static async _query(req, res) {
    let conceptos = await Concepto.findAll({ where : req.query });
    conceptos = await Promise.all(conceptos.map(ConceptosApi._serialize_concepto));
    res.json(conceptos);
  }

  static async _nearbyQuery(req, res) {
    let lat = req.query["latitud"];
    let lng = req.query["longitud"];
    let radius = req.query["radio"];
    let conceptos = await Concepto.findAll({});
    conceptos = await Promise.all(conceptos.map(ConceptosApi._serialize_concepto));
    var pointToFindConcepts = {latitude: lat, longitude: lng};
    var nearbyConcepts = conceptos.filter(concepto =>
      ConceptosApi._getDistanceInMeters(pointToFindConcepts, {latitude: concepto['latitud'], longitude: concepto['longitud']}) <= radius);
    res.json(nearbyConcepts);
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

  // https://stackoverflow.com/a/21623206/6843675
  static _getDistanceInMeters(coor1, coor2){
    var [lat1, lon1] = [coor1.latitude, coor1.longitude]
    var [lat2, lon2] = [coor2.latitude, coor2.longitude]
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a))*1000;
  }
}

const router = new ConceptosApi().router;
export default router;