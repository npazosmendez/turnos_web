var config = {};

config.port = process.env.PORT || 3000;
config.https = Boolean(process.env.HTTPS) || false;
config.ssl_cert = process.env.SSL_CERT;
config.ssl_private = process.env.SSL_PRIVATE;
config.mail_user = process.env.MAIL_USER;
config.mail_password = process.env.MAIL_PASSWORD;

console.log("Usando config:")
console.log(config)

export default config;