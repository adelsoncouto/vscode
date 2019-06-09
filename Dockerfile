FROM ubuntu:18.04
LABEL maintainer="Adelson Silva Couto <adscouto@gmail.com>"

USER root

# Dependências
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone
RUN DEBIAN_FRONTEND=noninteractive \
  && sed 's/main$/main universe/' -i /etc/apt/sources.list \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
  apt-transport-https \
  aspell \
  autogen \
  automake \
  build-essential \
  chromium-browser \
  chromium-chromedriver \
  curl \
  emacs \
  gettext \
  git \
  graphviz \
  gvfs-bin \
  htop \
  iproute2 \
  iputils-ping \
  jq \
  libasound2 \
  libc6-dev \
  libcairo2 \
  libcanberra-gtk-module \
  libcurl4 \
  libfontconfig1 \
  libgconf2-4 \
  libgl1-mesa-glx \
  libglib2.0-bin \
  libgtk-3-0 \
  libnotify-dev \
  libnss3-dev \
  libpango-1.0-0 \
  libstdc++6 \
  libtool \
  libxext-dev \
  libxkbfile1 \
  libxrender-dev \
  libxss1 \
  libxtst-dev \
  locales \
  mono-complete \
  openssl \
  rxvt-unicode-256color \
  software-properties-common \
  sudo \
  unzip \
  vim \
  mariadb-client-10.1 \
  x11-xserver-utils \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen pt_BR.UTF-8

# variáveis gerais
ENV TZ="America/Sao_Paulo" \
  LANG="pt_BR.UTF-8" \
  LANGUAGE="pt_BR:pt:en" \
  LC_CTYPE="pt_BR.UTF-8" \
  LC_NUMERIC="pt_BR.UTF-8" \
  LC_TIME="pt_BR.UTF-8" \
  LC_COLLATE="pt_BR.UTF-8" \
  LC_MONETARY="pt_BR.UTF-8" \
  LC_MESSAGES="pt_BR.UTF-8" \
  LC_PAPER="pt_BR.UTF-8" \
  LC_NAME="pt_BR.UTF-8" \
  LC_ADDRESS="pt_BR.UTF-8" \
  LC_TELEPHONE="pt_BR.UTF-8" \
  LC_MEASUREMENT="pt_BR.UTF-8" \
  LC_IDENTIFICATION="pt_BR.UTF-8" \
  JAVA_HOME="/usr/src/jvm/java" 

# maven
RUN mkdir /usr/src/mvn \
  && cd /usr/src/mvn \
  && curl -fSL https://www-eu.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz -o apache.tar.gz \
  && tar -zxf apache.tar.gz \
  && rm -rf apache.tar.gz \
  && for n in $(ls);do mv ./$n/* ./;rm -rf ./$n;done \
  && chmod +x /usr/src/mvn/bin -R

# openjdk 11
RUN mkdir -p /usr/src/jvm/java11 \
  && cd /usr/src/jvm/java11 \
  && curl -fSL https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz -o java.tar.gz \
  && tar -zxf java.tar.gz \
  && rm -rf java.tar.gz \
  && for n in $(ls);do mv ./$n/* ./;rm -rf ./$n;done \
  && cd /usr/src/jvm \
  && chmod +x /usr/src/jvm/java11/bin -R \
  && ln -s /usr/src/jvm/java11 java 

# dbeaver
RUN mkdir /usr/src/dbeaver \
  && cd /usr/src/dbeaver \
  && curl -fSL https://dbeaver.io/files/6.0.5/dbeaver-ce-6.0.5-linux.gtk.x86_64.tar.gz -o dbeaver.tar.gz \
  && tar -zxf dbeaver.tar.gz \
  && rm -rf dbeaver.tar.gz \
  && mv dbeaver dbeaver-dir \
  && for n in $(ls);do mv ./$n/* ./;rm -rf ./$n;done \
  && chmod +x /usr/src/dbeaver/dbeaver

# mongodb
RUN mkdir -p /usr/src/mongodb \
  && mkdir -p /data/db \
  && mkdir -p /var/log/mongodb \
  && cd /usr/src/mongodb \
  && curl -fSL 'http://downloads.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.0.5.tgz' -o mongodb.tgz \
  && tar -zxf mongodb.tgz \
  && rm -rf mongodb.tgz \
  && for n in $(ls);do mv ./$n/* ./;rm -rf ./$n;done \
  && chmod +x /usr/src/mongodb/bin -R

# instalo o nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs

# instalo outros complementos
RUN npm install -g npm \
  && npm install -g cordova \
  && npm install -g typescript \
  && npm install -g @angular/cli \
  && npm install -g ionic

# instalo o vscode
RUN curl -fSL  https://go.microsoft.com/fwlink/?LinkID=760868 -o vscode-amd64.deb \
  && dpkg -i vscode-amd64.deb \
  && rm vscode-amd64.deb

# remove temporário
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && mkdir -p /usr/src/init \
  && ln -s /usr/src/jvm/java/bin/* /usr/local/sbin/ \
  && ln -s /usr/src/mvn/bin/* /usr/local/sbin/ \
  && ln -s /usr/src/mongodb/bin/* /usr/local/sbin/ \
  && ln -s /usr/src/dbeaver/dbeaver /usr/local/sbin/dbeaver

# instalo as extenções
RUN mkdir -p /tmp/code \
  && mkdir -p /tmp/extensions \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension MS-CEINTL.vscode-language-pack-pt-BR \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension vscjava.vscode-java-pack \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension shengchen.vscode-checkstyle \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension mikael.angular-beastcode \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension thekalinga.bootstrap4-vscode \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension vscjava.vscode-java-dependency \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension vscjava.vscode-java-debug \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension vscjava.vscode-java-test \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension redhat.java \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension vscjava.vscode-maven \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension visualstudioexptteam.vscodeintellicode \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension alphabotsec.vscode-eclipse-keybindings \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension fatihacet.gitlab-workflow \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension jebbs.plantuml \
  && /usr/bin/code \
  --user-data-dir /tmp/code \
  --extensions-dir /tmp/extensions \
  --install-extension peterjausovec.vscode-docker

# script inicial
COPY ./settings.json /tmp/code/User/settings.json
COPY ./keybindings.json /tmp/code/User/keybindings.json
COPY ./snippets /tmp/code/User/snippets
COPY ./locale.json /tmp/code/User/locale.json
RUN mkdir -p /usr/src/init
COPY ./start.sh /usr/src/init/start.sh
RUN chmod +x /usr/src/init/start.sh

# inicia o bash
CMD ["/usr/src/init/start.sh"]
