import express from 'express';
import { Concepto, Turno, Usuario } from "../models/index.js";
import mailer from "../TurnosMailer.js";
import {basicAuthMiddleware} from "../middlewares/auth.js";

class TurnosApi {
  constructor() {
    this.router = express.Router();
    this.router.use(basicAuthMiddleware);
    this.router.get('/', TurnosApi.query);
    this.router.post('/', TurnosApi.create);
    this.router.get('/:id/personas_adelante', TurnosApi.personas_adelante);
    this.router.post('/:id/dejar_pasar', TurnosApi.dejar_pasar);
  }

  static async query(req, res) {
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
  }

  static async create(req, res) {
    // TODO: error handling (o mejor enchufarlo en el pipeline de obtenerConcepto)
    let concepto = await Concepto.findOne({
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
    }).then(async (turno) => {
      mailer.notificar_proximo_en_fila_para(await turno.getConcepto(), turno);
      res.send(turno);
    }).catch((err) => res.status(500).send(err.message));
  }

  static async personas_adelante(req, res, next) {
    try {
      const turno = await Turno.findByPk(req.params.id);
      const result = await turno.personas_adelante();
      res.send(result.toString());
    } catch (err) {
      next(err);
    }
  }

  static async dejar_pasar(req, res, next) {
    try {
      let turno = await Turno.findByPk(req.params.id);
      let turno_de_atras = await turno.turno_de_atras();

      if(!turno_de_atras) {
        return res.status(400).send("No hay nadie a quien dejar pasar.");
      }

      // Known issue: altas race conditions acá compadre
      let [numero_adelante, numero_atras] = [turno.numero, turno_de_atras.numero];
      turno.numero = numero_atras;
      turno_de_atras.numero = numero_adelante;
      await turno.save();
      await turno_de_atras.save();

      mailer.notificar_proximo_en_fila_para(await turno_de_atras.getConcepto(), turno_de_atras);

      return res.send(turno);
    } catch (err) {
      next(err);
    }
  }
}

const router = new TurnosApi().router;
export default router;