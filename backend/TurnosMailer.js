import nodeMailer from "nodemailer";

export class TurnosMailer {
  constructor() {
    this.transporter = nodeMailer.createTransport({
      host: 'smtp.gmail.com',
      port: 465,
      secure: true,
      auth: {
        // TODO: move to config
        user: 'turnoslocos@gmail.com',
        pass: 'tparqweb'
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
    const subject = `[TurnosWeb-${concepto.nombre}] Sos el proximo en la fila!`;
    const text = `<div style="width: 100%">
                    <h3>Sos el próximo en la fila de ${concepto.nombre}</h3>
                    <div>Tu número</div>
                    <h1>${prox_turno.numero}</h1>
                  </div>`
    return this.enviar_mail(prox_usuario.email, subject, text).then((info) => {
      console.log('Message %s sent: %s', info.messageId, info.response);
      return info;
    }).catch((err) => {
      console.error(err);
      return Promise.reject(err);
    });
  }
}