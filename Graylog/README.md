## Install Docker and Docker-compose
```
apt install docker.io
apt install docker-compose
sudo usermod -aG docker $USER
newgrp docker

docker version
docker-compose version

```
## Provision to Graylog Container
```

```
## Create Persistent Volume 
```
sudo mkdir /mongo_data
sudo mkdir /es_data
sudo mkdir /graylog_journal

```
## Set the write permission 
```
sudo chmod 777 -R /mongo_data
sudo chmod 777 -R /es_data
sudo chmod 777 -R /graylog_journal


```
## Run 
```
docker-compose up -d

```
## Check the container Status
```
docker ps
```
## If you have a firewall enabled, allow the Graylog service port through it.
```
sudo ufw allow 9000/tcp
```

## Access the Graylog Web UI
```
Your_server_IP:9000
```
