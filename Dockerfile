# -- Build Flutter --
# ~~~~~~~~~~~~~~~~~~~
FROM cirrusci/flutter:beta AS flutter_builder
ADD frontend /usr/frontend
WORKDIR /usr/frontend
USER root
RUN flutter config --enable-web && flutter pub get && flutter build web

# -- Build Node.js --
# ~~~~~~~~~~~~~~~~~~~~~~~~~
FROM node:12 AS node_builder
ADD backend /usr/backend
WORKDIR /usr/backend
RUN npm install && npm run dist

# -- Run Node.js server --
# ~~~~~~~~~~~~~~~~~~~~~~~~~
FROM node:12
COPY --from=node_builder /usr/dist /usr/app
COPY --from=flutter_builder /usr/frontend/build/web /usr/app/static
WORKDIR /usr/app
CMD ["node", "app.js"]
