#!/bin/bash

# crio grupo
groupadd -r $USER_NAME -g $USER_ID 

# cria o diretório do usuário
if [[ ! -d '/home/'"$USER_NAME" ]];then
  mkdir -p '/home/'"$USER_NAME"
fi

# crio usuario
useradd -u $USER_ID -r -d /home/$USER_NAME -g $USER_NAME -p root -s /bin/bash -c "$USER_FULL" $USER_NAME

# permissoes do usuario
echo "$USER_NAME"' ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# imprimo a ajuda ajuda
echo 'Para usar digite um dos seguintes comandos (use o & para não travar o terminal): '
echo '  code         - Abre o vscode'
echo '  dbeaver      - Dbeaver'
echo '  mongodb      - Mongo db'
echo '  node         - NodeJS'

# muda para o diretorio do usuario
cd '/home/'"$USER_NAME"

# recuperando configuracoes
if [[ ! -d '/home/'"$USER_NAME"'/.vscode' ]];then
  mkdir -p '/home/'"$USER_NAME"'/.config'
  mkdir -p '/home/'"$USER_NAME"'/.vscode'
  cp -r '/tmp/extensions' '/home/'"$USER_NAME"'/.vscode/'
  cp -r '/tmp/code' '/home/'"$USER_NAME"'/.config/Code'
  chown -R $USER_NAME:$USER_NAME '/home/'"$USER_NAME"
fi

# mudo para o usuario criado
su $USER_NAME

