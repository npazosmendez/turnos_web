var config = {};

config.port = process.env.PORT || 3443;
config.https = Boolean(process.env.HTTPS) || false;
config.ssl_cert = "/etc/ssl/certs/turnos.cert";
config.ssl_private = "/etc/ssl/private/turnos.key";

module.exports = config;

console.log("Usando config:")
console.log(config)