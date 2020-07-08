# Partimos de imagen base de node 12. A la imagen que estamos creando le ponemos el nombre "dev"
FROM node:12 AS dev

ARG APPPATH=/usr/app

WORKDIR ${APPPATH}

# Se declara el puerto usado en entorno de desarrollo
EXPOSE 3000

# Primero se copia package.json, si no se modifica, la instalacion de la bibliotecas queda cacheada. 
COPY package.json package-lock.json ${APPPATH}/

RUN npm install --only=production

# Se copia el resto del codigo
COPY . ${APPPATH}

# Se declaran las carpetas donde se montara el codigo
VOLUME ${APPPATH}/api ${APPPATH}/middlewares ${APPPATH}/models

CMD ["node", "app.js"]

# Nuevo stage "prod". Se parte de la imagen de desarrollo.
FROM dev as prod

# Se copian los estaticos de frontend de la imagen ya buildeada
COPY --from=frontend_build /usr/app/build/web /usr/app/static

CMD ["node", "app.js"]

