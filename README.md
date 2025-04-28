
## CREAR SUBDOMINIO Y APUNTAR AL IP DE SU VPS

Probado en ubuntu 20 y 22

Editar archivo config y poner contraseñas de su preferencia y su correo electrónico, dominios.

Si desea instalar 2 instancias cambie el nombre de la instancia, puerto backend, puerto frontend y puerto_postgre_instancia, no debe utilizar los mismos puertos de otras instalaciones

La opción actualizar tomará la última versión del repositorio usado para instalar

Nunca use los puertos 80 y 443 para backend, utilice el puerto 3000 al 3100 y frontend 4000 al 4100

## VERIFICAR PROPAGACIÓN DEL DOMINIO

https://dnschecker.org/

## EJECUTAR LOS SIGUIENTES COMANDOS ##

Antes de iniciar verifique en el sitio arriba si propagó el dns. Para no tener error en la instalación

Para evitar errores se recomienda actualizar el sistema y después de actualizar reiniciar para evitar errores

```bash
apt -y update && apt -y upgrade
```
```bash
reboot
```

Después de reiniciar siga con la instalación

```bash
cd /root
```
```bash
git clone https://github.com/basorastudio/remoto.git remoto
```
Editar datos con sus datos, con nano para guardar presione Ctrl + x

Puede definir el timezone deseado usando la variable de entorno TIMEZONE. Si no se informa, el sistema usará el timezone por defecto: America/Sao_Paulo.
```bash
nano ./remoto/config
```

```bash
sudo chmod +x ./remoto/izing
```
```bash
cd ./remoto
```
```bash
sudo ./izing
```

## ¿Problemas de conexión con whatsapp? ##

Intente actualizar el Conector WWebJS whatsapp.js

## Recomendación de instalar y dejar el Firewall activado

Su servidor puede sufrir ataques externos que hacen que el sistema se bloquee y tenga caídas, por favor instale y mantenga el firewall activado.
Utilizado UFW para saber más busque en google.


## Cambiar Frontend

Para cambiar el nombre de la aplicación:

/home/deploy/izing.io/frontend/quasar.conf

/home/deploy/izing.io/frontend/src/index.template.html

Para cambiar logos e iconos:

carpeta /home/deploy/izing.io/frontend/public

Para cambiar colores:

/home/deploy/izing.io/frontend/src/css/app.sass

/home/deploy/izing.io/frontend/src/css/quasar.variables.sass

Siempre cambiar usando el usuario deploy, puede conectar el servidor con la aplicación Bitvise SSH Client. Después de los cambios compilar nuevamente el Frontend

```bash
su deploy
```
```bash
cd /home/deploy/carpetaondeestainstalado/frontend/
```
```bash
export NODE_OPTIONS=--openssl-legacy-provider
```
```bash
npx quasar build -P -m pwa
```

Probar los cambios en una pestaña anónima

## Errores

"Internal server error: SequelizeConnectionError: could not open file \"global/pg_filenode.map\": Permission denied"

```bash
docker container restart postgresql
```
```bash
docker exec -u root postgresql bash -c "chown -R postgres:postgres /var/lib/postgresql/data"
```
```bash
docker container restart postgresql
```

## Acceso Portainer generar contraseña
"Su instancia de Portainer se agotó por motivos de seguridad. Para volver a habilitar su instancia de Portainer, deberá reiniciar Portainer."

```bash
docker container restart portainer
```

Después acceda nuevamente a la url http://suip:9000/