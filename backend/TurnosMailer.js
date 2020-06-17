import nodeMailer from "nodemailer";
import os from 'os';
import config from './config.js';

class TurnosMailer {
  constructor() {
    this.transporter = nodeMailer.createTransport({
      host: 'smtp.gmail.com',
      port: 465,
      secure: true,
      auth: {
        user: config.mail_user,
        pass: config.mail_password
      }
    });
  }

  enviar_mail(to, subject, html) {
    return this.transporter.sendMail({ to, subject, html });
  }

  async notificar_proximo_en_fila_para(concepto, candidato_a_proximo=null) {
    // Llamar sin await, no es necesario que responda para responder el request

    const prox_turno = await concepto.siguiente(true);
    if (!prox_turno) return;
    // Si el proximo no es el candidato, no mandamos mail
    if (candidato_a_proximo && prox_turno.id !== candidato_a_proximo.id) return;

    const prox_usuario = prox_turno.usuario;
    const htmlFileName='t+'+prox_turno.uuid+'.html';
    const subject = `Sos el próximo en la fila!`;
    var prot;
    if (config.https){prot="https://";} else {prot="http://";}
    const host=config.host;
    const port=config.port;
    const url=prot+host+":"+port+"/tmp/"+htmlFileName;
    const text = `<div style="width: 100%">
                  <h3>Sos el próximo en la fila de ${concepto.nombre}</h3>
                  <div>Tu número</div>
                  <h1>${prox_turno.numero}</h1>
                  <a href="${url}">Clicá acá para ver los detalles</a>
                </div>`
    return this.enviar_mail(prox_usuario.email, subject, text).then((info) => {
      console.log('Message %s sent: %s', info.messageId, info.response);
      console.log(text);
      return info;
    }).catch((err) => {
      console.error(err);
      return Promise.reject(err);
    });
  }
}

const mailer = new TurnosMailer();

export default mailer;