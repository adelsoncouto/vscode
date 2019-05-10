# VSCODE

Container de desenvolvimento vscode

# USO

```bash
docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v /home/$USER:/media/trabalho \
  --hostname vscode\
  --name vscode \
  -e USER_ID=`id -u` \
  -e USER_NAME=$USER \
  -e USER_FULL=$USERNAME \
  -e DISPLAY \
  --memory=4G \
  adelsoncouto/vscode:tagname
```

# Ambiente

* OpenJDK 11
* Debeaver 
* Visual Studio Code
* NodeJS
* Maven
* Mongodb


# Futuro

* Instalar https://www.geany.org
