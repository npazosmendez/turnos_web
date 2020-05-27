
var bypass = true;

async function basicAuth(req, res, next) {
    if(bypass) {
        req.username = "dummy_username"
    } else {

        if (!req.headers.authorization || req.headers.authorization.indexOf('Basic ') === -1) {
            return res.status(401).json({ message: 'Missing Authorization Header' });
        }
    
        const base64Credentials =  req.headers.authorization.split(' ')[1];
        const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
        const [username, password] = credentials.split(':');
        // TODO: validar
    
        req.username = username
    }
    console.log("Authenticated:", req.username)
    next();
}

exports.basicAuth = basicAuth
