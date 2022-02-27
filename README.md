# Desafio Devops

> Um desafio para provisionar uma infraestrutura de aplicativos e observabilidade no Kubernetes

[![made-with-python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)](https://www.python.org/) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)


# Arquivos

Os arquivos do projeto estão estruturados da seguinte forma:

    desafio-devops
    ├── k8s-deploy-simpleapp-python    # Arquivos de deploy da aplicação
    ├── k8s-deploy-stack-logs          # Arquivos de deploy do ambiente de logs
    ├── k8s-deploy-stack-metrics       # Arquivos de deploy do ambiente de métricas
    └── src-simpleapp-python           # Código fonte da aplicação e script para build da imagem

# Preparação do ambiente

Para provisionar o ambiente escolhi o minikube para facilitar os testes localmente com algumas configurações adicionais de cpu e memória para executar todos os ambientes em conjunto (aplicação, stack de métricas/logs).

Importante: você preciasa de um software de virtualização como Virtual Box para executar o minikube.

```bash

# instalar minikube
# https://minikube.sigs.k8s.io/docs/start/
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
$ sudo install minikube-linux-amd64 /usr/local/bin/minikube

# configurações adicionais do ambiente para execução
$ minikube config set memory 8192
$ minikube config set cpus 8

# inicializar o ambiente
$ minikube start
😄  minikube v1.25.1 on Ubuntu 18.04
✨  Using the virtualbox driver based on existing profile
👍  Starting control plane node minikube in cluster minikube
.
.
.

# validar configurações de CPU e memória do minikube
$ vboxmanage showvminfo minikube | grep "Memory size\|Number of CPUs"
Memory size:     8192MB
Number of CPUs:  8

```

# Build da imagem e upload para Docker Hub

```bash

$ cd src-simpleapp-python
$ docker build -t simpleapp-python3 .
$ docker tag simpleapp-python:latest <hub-user>/<repo-name>:latest
$ docker push <hub-user>/<repo-name>:latest

```

# Deploy da aplicação no minikube

```bash

$ kubectl apply -f ./src-simpleapp-python-k8s-deploy/simpleapp-cm.yml
$ kubectl apply -f ./src-simpleapp-python-k8s-deploy/simpleapp.yml

```

# Instalação do Prometheus/Grafana via helm

```bash

$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo add stable https://charts.helm.sh/stable
$ helm repo update
$ helm install prometheus prometheus-community/kube-prometheus-stack

$ kubectl port-forward deployment/prometheus-grafana 3000
http://localhost:3000

```

Acessar o grafana com os seguintes usuário e senha:

```
user: admin
password: prom-operator
```

# Configurar stack de logs

```bash

$ helm install elasticsearch elastic/elasticsearch -f ./k8s-deploy-stack-logs/elasticsearch-master.yaml
$ helm install dashboard elastic/kibana -f ./k8s-deploy-stack-logs/kibana.yaml


$ kubectl port-forward svc/dashboard-kibana 5601
http://localhost:3000

```

# Envio de logs para elasticsearch

```bash

$ helm install fluent-bit fluent/fluent-bit  -f ./k8s-deploy-stack-logs/fluent-bit.yaml

```
