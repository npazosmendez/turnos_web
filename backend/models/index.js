import Sequelize from 'sequelize';
import { db } from './db.js';
import { v4 as uuidv4 } from 'uuid'; // v4=random uuid
import QRCode from 'qrcode';
import * as fs from 'fs';

/*
 * MODELO USUARIO
 */

export const Usuario = db.define('usuarios', {
  email: {
    type: Sequelize.TEXT,
    allowNull: false,
  },
  password: {
    type: Sequelize.TEXT,
    allowNull: false,
  },
  nombre: {
    type: Sequelize.TEXT,
    allowNull: false,
  },
  apellido: {
    type: Sequelize.TEXT,
    allowNull: false,
  },
});

/*
 * MODELO CONCEPTO
 */

export class Concepto extends Sequelize.Model {

  // No me sirve como método de instancia porque se usa para plain objects
  static async enFila(conceptoId) {
    return Turno.count({
      where : {
        conceptoId: conceptoId,
      }
    });
  }

  async siguiente(include_usuario=false) {
    // include_usuario indica si la respuesta contiene el usuario asociado o no

    const siguiente_numero = await Turno.min("numero", {
      where: { conceptoId: this.id}
    });
    if (isNaN(siguiente_numero)) {
      return null;
    }

    let included_related_models = [];
    if (include_usuario) {
      included_related_models.push({ model: Usuario });
    }
    return Turno.findOne({
      where: {
        conceptoId: this.id,
        numero: siguiente_numero,
      },
      include: included_related_models
    });
  }

  async filaLlena() {
    return this.maximaEspera && this.maximaEspera <= await Concepto.enFila(this.id);
  }
}

Concepto.init({
  habilitado: {
    type: Sequelize.BOOLEAN,
    allowNull: false,
    defaultValue: true
  },
  nombre: {
    type: Sequelize.STRING,
    allowNull: false,
    len: [3,50]
  },
  descripcion: {
    type: Sequelize.STRING,
    allowNull: false,
    len: [3,50]
  },
  latitud: {
    type: Sequelize.FLOAT,
    allowNull: false
  },
  longitud: {
    type: Sequelize.FLOAT,
    allowNull: false
  },
  pathImagen: {
    type: Sequelize.STRING,
    allowNull: true,
    defaultValue: null,
  },
  maximaEspera: {
    type: Sequelize.INTEGER,
    allowNull: true,
    defaultValue: null,
  },
}, {
  sequelize: db,
  modelName: "concepto",
});

/*
 * MODELO TURNO
 */

export class Turno extends Sequelize.Model {
  static async proximo_numero(conceptoId) {
    const maximo = await this.max("numero", { where: { conceptoId: conceptoId }});
    return isNaN(maximo) ? 1 : maximo + 1;
  }

  static async create({conceptoId, usuarioId}, options) {
    const uuid=uuidv4();
    const numero=await this.proximo_numero(conceptoId);
    return super.create({
      conceptoId: conceptoId,
      usuarioId: usuarioId,
      numero: numero,
      uuid: uuid
    }, options);
    const qrFileName='tmp/qr+'+numero.toString()+'+'+uuid+'.png';
    QRCode.toFile(qrFileName,numero.toString()+'+'+uuid, { errorCorrectionLevel: 'H' });
    const text = `<div style="width: 100%">
                  <h3>Turno para ${concepto.nombre}</h3>
                  <div>Tu número</div>
                  <h1>${numero}</h1>
                  <br/>
                  <img src="${qrFileName}"></img>
                </div>`
    fs.writeFile("./tmp/koko.html", "hola", function (err) {
      if (err) return console.log(err);
      console.log('Hello World > helloworld.txt');
    });
  }

  async personas_adelante() {
    return Turno.count({
      where: {
        conceptoId: this.conceptoId,
        numero: {
          [Sequelize.Op.lt]: this.numero
        }
      }
    });
  }

  async turno_de_atras() {
    const numero_de_atras = await Turno.min("numero", {
      where : {
        conceptoId: this.conceptoId,
        numero: {
          [Sequelize.Op.gt]: this.numero
        }
      }
    });
    if (isNaN(numero_de_atras)) {
      return null;
    }
    return Turno.findOne({
      where: {
        conceptoId: this.conceptoId,
        numero: numero_de_atras,
      },
    });

  }
}

Turno.init({
  numero: Sequelize.INTEGER,
  uuid: Sequelize.CHAR,
}, {
  sequelize: db,
  modelName: "turno",
});

/*
 * RELACIONES ENTRE MODELOS
 */
Usuario.hasMany(Turno, {
  foreignKey: {
    allowNull: false
  }
});
Turno.belongsTo(Usuario);

Usuario.hasMany(Concepto, {
  foreignKey: {
    allowNull: false
  }
});
Concepto.belongsTo(Usuario);

Concepto.hasMany(Turno, {
  foreignKey: {
    allowNull: false
  }
});
Turno.belongsTo(Concepto);

import './fixtures.js'