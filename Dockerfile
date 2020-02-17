FROM jenkins/jenkins

USER root

# Instalando Docker
RUN apt-get update && \
   apt-get -y install apt-transport-https \
   ca-certificates \
   curl \
   gnupg2 \
   software-properties-common && \
   curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
   add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
   apt-get update && \
   apt-get -y install docker-ce

# Instalando Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" \
   -o /usr/local/bin/docker-compose && \
   chmod +x /usr/local/bin/docker-compose

RUN usermod -aG docker jenkins

# Instalando Gcloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
   echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
   curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
   sudo apt-get update && \
   sudo apt-get install -y google-cloud-sdk

# Configuración de docker con gcp
RUN gcloud auth configure-docker --quiet