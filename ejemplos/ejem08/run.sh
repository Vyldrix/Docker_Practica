#!/bin/bash
docker rmi  -f ejem08
docker rm   -f ejem08
docker build -t ejem08 .
docker run -dit --name ejem08 -p 8088:80 ejem08
