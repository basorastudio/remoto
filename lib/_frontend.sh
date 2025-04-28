#!/bin/bash
# 
# funciones para configurar el frontend de la aplicación

#######################################
# paquetes de node instalados
# Arguments:
#   None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependencias del frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/${nome_instancia}/frontend
  npm install --force
  npm i @quasar/cli
EOF

  sleep 2
}

#######################################
# compila el código del frontend
# Arguments:
#   None
#######################################
frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando el código del frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/${nome_instancia}/frontend
  export NODE_OPTIONS=--openssl-legacy-provider
  npx update-browserslist-db@latest
  npx quasar build -P -m pwa
EOF

  sleep 2
}


#######################################
# establece las variables de entorno del frontend
# Arguments:
#   None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variables de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # asegurar idempotencia
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/${nome_instancia}/frontend/.env
  VUE_URL_API=${backend_url}
  VUE_FACEBOOK_APP_ID='23156312477653241'
[-]EOF
EOF

  sleep 2
}

#######################################
# genera archivo server.js
# 
#   
#######################################
frontend_serverjs() {
  print_banner
  printf "${WHITE} 💻 generar archivo server.js (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/${nome_instancia}/frontend/server.js
// servidor express simple para ejecutar la compilación de producción del frontend;
const express = require('express')
const path = require('path')
const app = express()
app.use(express.static(path.join(__dirname, 'dist/pwa')))
app.get('/*', function (req, res) {
  res.sendFile(path.join(__dirname, 'dist/pwa', 'index.html'))
})
app.listen(${frontend_porta})
[-]EOF
EOF

  sleep 2
}

#######################################
# inicia el frontend usando pm2 en 
# modo de producción.
# Arguments:
#   None
#######################################
frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/${nome_instancia}/frontend
  pm2 start server.js --name ${nome_instancia}-frontend
  pm2 save
EOF

  sleep 2
}

#######################################
# configura nginx para el frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/${nome_instancia}-frontend << 'END'
server {
  server_name $frontend_hostname;
  
    location / {
    proxy_pass http://127.0.0.1:${frontend_porta};
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}


END

ln -s /etc/nginx/sites-available/${nome_instancia}-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}
