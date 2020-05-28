# turnos_web

Para correr el backend:

```shell
cd backend
PORT=8080 node app.js
```
Esto también sirve los estáticos que buildea Flutter.

Para buildear el frontend:
```shell
flutter build web
```

Para levantar el frontend en Chrome en modo dev:
```shell
cd frontend
flutter run -d chrome
```

# Decisiones
- Tenemos "Usuarios", pueden ser tanto propietarios como clientes
- Por ahora no hay sign-up. Los usuarios están hardcodeados.
