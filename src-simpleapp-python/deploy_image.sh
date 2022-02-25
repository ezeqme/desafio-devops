#!/bin/bash
docker build -t simpleapp-python3 .
docker tag simpleapp-python:latest ezequielsbarros/simpleapp-python:latest
docker push ezequielsbarros/simpleapp-python:latest
