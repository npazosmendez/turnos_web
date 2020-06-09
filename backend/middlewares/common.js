
export function noCacheMiddleware(req, res, next) {
  res.set('Cache-Control', 'no-store'); // Deshabilita el caché
  next();
}

export function errorHandlingMiddleware(err, req, res, next) {
  console.error("ERROR: " + err);
  res.status(500).send(err.message);
}