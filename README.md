# Wordpress Setup Using Kubernetes

## Pre-requisites
1. Kubernetes Cluster - Setup a Kubernetes cluster, You can use managed kubernetes services like  `Google Kubernetes Enginer (GKE)`, `AWS (EKS)`or `Azure (AKS)`

2. Kubectl:- install the `kubectl` command line tool to interact with your kubernetes cluster

3. Container Registry:- Choose a Container Registry eg.-`Docker Hub`,`Google Container Registry (GCR)`or `Amazon (ECR)` to Store your wordpress and mysql images

Steps: 
     1. Create kubernetes Deployment and Services
     2. Create Secrets for MySQL Passwords:
     3. Apply Configurations:
     4. Access WordPress:
     5. Scale if Needed:


## 1. Create kubernetes Deployment and Services
Create YAML files for the WordPress and MySQL deployments and services. Below are simplified examples:

Create wordpress-deployment.yaml file
```
sudo touch wordpress-deployment.yaml
```
open file 
```
sudo nano wordpress-deployment.yaml
```
Paste the Value
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: your-registry/wordpress:latest
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql-service
        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: password
---
apiVersion: v1
kind: Service
metadata:
  name: wordpress-service
spec:
  selector:
    app: wordpress
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer

```


Now Create mysql-deployment.yaml: file
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: your-registry/mysql:latest
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: root-password
        - name: MYSQL_DATABASE
          value: wordpress
        - name: MYSQL_USER
          value: wordpress
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: password
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  selector:
    app: mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306

```

## 2. Create Secrets for MySQL Passwords:
Create a secret to store MySQL passwords.
```
sudo touch mysql-secret.yaml
```
Open mysql-secret.yaml
```
sudo nano mysql-secret.yaml
```
Paste the value
```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
data:
  password: <base64-encoded-password>
  root-password: <base64-encoded-root-password>

```
### You can use the following command to generate base64-encoded strings for your passwords:

```
echo -n 'your-password' | base64

```

## 3. Apply Configurations:
Apply the configurations to your Kubernetes cluster:

```
kubectl apply -f mysql-secret.yaml
```

```
kubectl apply -f mysql-deployment.yaml
```

```
kubectl apply -f wordpress-deployment.yaml

```


## 4. Access WordPress:

Wait for the LoadBalancer IP to be assigned (or use NodePort, depending on your setup):

```
kubectl get services -o wide

```
### Access WordPress using the assigned IP. Complete the WordPress installation process through the web interface.

5. Scale if Needed:
You can scale your deployments based on your needs:

```
kubectl scale deployment wordpress --replicas=<desired-replicas>
kubectl scale deployment mysql --replicas=<desired-replicas>

```
All Task are available with full explanation 



## Working Noge-agent Pipeline 

```
pipeline {
    agent {
        label 'testapp'
    }

    environment {
        APP_NAME = "myapp"
        DOCKER_USER = "dockt35t"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "latest"
        REMOTE_SERVER = 'ubuntu@35.154.149.28'
        REMOTE_PATH = '/home/ubuntu/app'
        SSH_CREDENTIALS = '35.154.149.28'
        LOCAL_PATH = '/var/lib/jenkins/workspace/testapp'
    }

    stages {
        stage("Checkout SCM") {
            steps {
                git branch: 'develop', credentialsId: 'github', url: 'https://github.com/test-202/app.git'
            }
        }
        stage("Build Docker Image") {
            steps {
                script {
                    docker.withRegistry('', DOCKER_PASS) {
                        def customImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                        customImage.push()
                    }
                }
            }
        }

        // stage("Deploy to Node") {
        //     steps {
        //         script {
        //             // Copy files to the remote node using SSH
        //             sshagent(credentials: ['35.154.149.28']) {
        //                 sh "scp -r ${LOCAL_PATH} ${REMOTE_SERVER}:${REMOTE_PATH}"
        //             }
        //         }
        //     }
        // }
        stage('Deploy to Node') {
            steps {
                script {
                    // Copy files to the remote node using SSH
                    sshagent(credentials: [SSH_CREDENTIALS]) {
                    sh "ssh ${REMOTE_SERVER} ' docker run -d --name myapp-container -p 8090:8000 ${IMAGE_NAME}:${IMAGE_TAG}'"
                    }
                }
            }
        }
    }
}
```
