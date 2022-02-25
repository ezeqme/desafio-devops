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

# Gerar imagem docker e realizar upload para Docker Hub

```bash

$ cd src-simpleapp-python
$ docker build -t simpleapp-python3 .
$ docker tag simpleapp-python:latest <hub-user>/<repo-name>:latest
$ docker tag simpleapp-python:latest <hub-user>/<repo-name>:latest
$ docker push <hub-user>/<repo-name>:latest

```
# Deploy da aplicação no minikube

```bash

$ kubectl apply -f ./src-simpleapp-python-k8s-deploy/simpleapp-cm.yml
$ kubectl apply -f ./src-simpleapp-python-k8s-deploy/simpleapp.yml

```
# Configurar monitoração no cluster via helm (Prometheus e Grafana)

```bash

$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo add stable https://charts.helm.sh/stable
$ helm repo update
$ helm install prometheus prometheus-community/kube-prometheus-stack

$ kubectl port-forward deployment/prometheus-grafana 3000
http://localhost:3000

```

Acessar o grafana com os seguintes usuário e senha:

user: admin
password: prom-operator

# Configurar stack de logs

```bash

$ helm install elasticsearch elastic/elasticsearch -f ./k8s-deploy-stack-logs/elasticsearch-master.yaml
$ helm install dashboard elastic/kibana -f ./k8s-deploy-stack-logs/kibana.yaml


$ kubectl port-forward svc/dashboard-kibana 5601
http://localhost:3000

```

# Configurar envio dos logs da aplicação para o elasticsearch

```bash

$ helm install fluent-bit fluent/fluent-bit  -f ./k8s-deploy-stack-logs/fluent-bit.yaml

```