FROM cirrusci/flutter:1.18.0-11.1.pre AS dev
ARG APPPATH=/usr/app
WORKDIR ${APPPATH}
EXPOSE 3001
USER root
COPY ./ ${APPPATH}
VOLUME ${APPPATH}/web ${APPPATH}/lib
RUN flutter config --enable-web && flutter pub get
CMD ["flutter", "run", "--machine", "--track-widget-creation", "--device-id=web-server", "--web-hostname=0.0.0.0", "--web-port=3001"]


FROM dev as build
RUN flutter build web