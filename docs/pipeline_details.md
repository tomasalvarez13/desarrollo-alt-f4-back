# Instrucciones build Pipeline CI
## Github Actions

Para el build de continuous integration (CI) de este repositorio se usó la herramienta provista por github para construir pipelines de CI GithubActions. 
Para ejecutar un pipeline con Github Actions se debe crear la carpeta .github/workflows/ en el directorio raíz. Dentro de este se debe crear un archivo  `nombre.yml`. 
Dentro de este archivo se agregaron las siguientes lineas de código:
```yml
name: "Ruby on Rails CI"
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Install Ruby and gems
        uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - name: Lint Ruby files
        run: bundle exec rubocop
```
Este archivo ejecuta el build del pipeline CI, es un pipeline simple que simula el ambiente de ruby on rails con el que trabajamos. 
Primero se asigna un nombre al flujo de trabajo o workflow.
Después se especifica a través de que ramas será ejecutado este script para realizar el build.
Finalmente, especificamos los jobs. En esta sección se ejecutan los comandos de revisión de código, se arma un ambiente ruby on rails que busca la versión que usamos en el container de docker a través del archivo `.ruby-version`. Después de haber instalado las dependencias ejecutamos el lintern de rubocop para revisar problemas de sintaxis en el código.

Como se mencionó antes, este pipeline es bastante simple y básico pero simula el ambiente dockerizado que tenemos y revisa los archivos con rubocop, lo que es una buena práctica de desarrollo.

