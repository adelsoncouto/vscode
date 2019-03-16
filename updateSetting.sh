#!/bin/bash

# verifico se foi informado o container
if [[ -z "$1" ]];then
  echo 'Informe o nome ou id do container'
  exit 1;
fi

# verifico se o container existe
container=$(docker ps --format '{{.Names}}' | grep "$1" | wc -l)
if [[ $container -lt 1 ]];then
  echo 'Container não econtrado'
  exit 1
fi

# verifico se foi informado o usuário do container
if [[ -z "$2" ]];then
  echo 'Informe o usuário do container'
  exit 1
fi

# removo o settings local se existir
rm -rf ./_k.json ./_s.json ./_s

# copio o settings do container
docker cp $1:/home/$2/.config/Code/User/keybindings.json ./_k.json
docker cp $1:/home/$2/.config/Code/User/settings.json ./_s.json
docker cp $1:/home/$2/.config/Code/User/snippets ./_s
docker cp $1:/home/$2/.config/Code/User/locale.json ./_l.json

# verifico se foi copiado com sucesso
ok=0
if [[ -f './_k.json' ]];then
  rm -rf ./keybindings.json
  mv ./_k.json ./keybindings.json
  echo 'Atualizado keybindings.json'
  ok=1
fi

if [[ -f './_s.json' ]];then
  rm -rf ./settings.json
  mv ./_s.json ./settings.json
  echo 'Atualizado settings.json'
  ok=1
fi

if [[ -d './_s' ]];then
  rm -rf ./snippets
  mv ./_s ./snippets
  echo 'Atualizado snippets'
  ok=1
fi

if [[ -f './_l.json' ]];then
  rm -rf ./locale.json
  mv ./_l.json ./locale.json
  echo 'Atualizado locale.json'
  ok=1
fi

if [[ $ok -eq 0 ]];then
  echo 'Não foi atualizado nada'
  exit 1
fi

# adiciono no git
git add -A keybindings.json settings.json snippets locale.json

# instrução
echo 'Atualize a versão no build.sh e faça o commit e push'

