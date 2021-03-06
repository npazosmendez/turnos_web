import { Usuario } from "../models/index.js";

function decodeAuthHeader(authHeader) {
    if (authHeader.indexOf('Basic ') === -1) {
        throw new Error('Solo se soporta Basic authorization');
    }
    const credentials =  authHeader.split(' ')[1];
    const [email, password] = credentials.split(':');
    if (!email || !password) {
        throw new Error('Auth header con formato incorrecto');
    }
    return [email, password];
}

export async function basicAuthMiddleware(req, res, next) {
    if (!req.headers.authorization) {
        console.log("Header 'Authorization' no presente.")
        return res.status(401).json({ message: "Header 'Authorization' no presente." });
    }

    let email, password;
    try {
        [email, password] = decodeAuthHeader(req.headers.authorization);
    } catch (err) {
        return res.status(401).json({ message: err.message });
    }

    var result = await Usuario.findAll({
        where: {
            email: email.toLowerCase(),
            password: password,
        }
    });
    if(result.length == 0 ) {
        console.log("Falló la autenticación de " + email + " " + password)
        return res.status(401).json({ message: 'Usuario o password incorrectas.' });
    }
    req.usuario = result[0];
    next();
}
