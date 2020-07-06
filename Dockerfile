# -- Build Flutter --
# ~~~~~~~~~~~~~~~~~~~
FROM cirrusci/flutter:beta AS flutter_builder
ADD frontend /usr/frontend
WORKDIR /usr/frontend
USER root
RUN flutter config --enable-web && flutter pub get && flutter build web

# -- Run Node.js server --
# ~~~~~~~~~~~~~~~~~~~~~~~~~
FROM node:12
COPY backend/ /usr/app
COPY --from=flutter_builder /usr/frontend/build/web /usr/app/static
WORKDIR /usr/app
RUN npm install --only=production
CMD ["node", "app.js"]
