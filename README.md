# turnos_web

Para correr el backend (80 es el puerto por defecto):

```shell
cd backend
node app.js <puerto>
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