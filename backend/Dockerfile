# -- Run Node.js server --
# ~~~~~~~~~~~~~~~~~~~~~~~~~
FROM node:12 AS dev
ARG APPPATH=/usr/app
WORKDIR ${APPPATH}
EXPOSE 3000
COPY package.json package-lock.json ${APPPATH}/
RUN npm install --only=production
COPY . ${APPPATH}
VOLUME ${APPPATH}/api ${APPPATH}/middlewares ${APPPATH}/models
CMD ["node", "app.js"]

FROM dev as prod
COPY --from=frontend_build /usr/app/build/web /usr/app/static
CMD ["node", "app.js"]

