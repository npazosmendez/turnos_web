# Partimos de imagen base de flutter 1.18. A la imagen que estamos creando le ponemos el nombre "dev"
FROM cirrusci/flutter:1.18.0-11.1.pre AS dev

ARG APPPATH=/usr/app

WORKDIR ${APPPATH}

# Se declara el puerto usado en entorno de desarrollo
EXPOSE 3001

USER root

# Se copia el codigo
COPY ./ ${APPPATH}

# Se declaran las carpetas donde se montara el codigo
VOLUME ${APPPATH}/web ${APPPATH}/lib

# Config de flutter e instalacion de dependencias
RUN flutter config --enable-web && flutter pub get

# Run server de desarrollo
CMD ["flutter", "run", "--machine", "--track-widget-creation", "--device-id=web-server", "--web-hostname=0.0.0.0", "--web-port=3001"]

# Nuevo stage build. Se parte de la imagen de desarrollo
FROM dev as build

# Se compila el codigo dart a html-css-js en un directorio dentro de la imagen
RUN flutter build web
