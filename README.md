# IIC2173 - E1 - G16 Backend

## Instrucciones para correr localmente el backend

Las instrucciones para correr localmente el backend, se encuentran en el archivo docs/run_description.txt

## Descripcion endpoints api

Existe un archivo llamado docs/endpoint_description.txt que contiene la descripcion de los bodies y response de todos los endpoints de la api.

## Link API
https://59bqnuyp9h.execute-api.us-east-1.amazonaws.com/

## Link FrontEnd
http://grupo-16-front-iic2173-2022-01.s3-website-us-east-1.amazonaws.com/

## Pipeline CI
El pipeline implementado en este repositorio se hizo con la herramienta Github Actions, el detalle se encuentra en docs/pipeline_details.md

## Conexión via ssh a aws

Para conectarse via ssh a aws, se debe utilizar el siguiente comando:
* ssh -i "e00.pem" ubuntu@ec2-3-88-206-145.compute-1.amazonaws.com
Nota: esta es la instancia de ec2 donde se encuentra alojadala api. Para acceder a esta utilizando los endpoints descritos anteriormente, se debe acceder a la api gateway, la cual tiene la siguiente URL:
* https://59bqnuyp9h.execute-api.us-east-1.amazonaws.com/location
* el archivo e00.pem será entregado segun lo solicitado por el ayudante.
# desarrollo-alt-f4-back
