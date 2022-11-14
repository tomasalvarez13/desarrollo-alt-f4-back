# README
## Creamos y migramos base de datos con las seeds
~~~
docker-compose run web rake db:create  
docker-compose run web rake db:migrate
docker-compose run web rake db:seed
~~~
## Corremos la aplicacion
~~~
docker compose up
~~~
## Para correr los test
~~~
docker-compose run web rake db:migrate RAILS_ENV=test
docker-compose run web rake test
~~~


## Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
