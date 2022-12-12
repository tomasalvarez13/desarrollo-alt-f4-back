# README
## Creamos y migramos base de datos con las seeds
~~~
docker-compose run web rake db:create  
docker-compose run web rake db:migrate
docker-compose run web rake db:seed
~~~
## Corremos la
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


## Environment variables

````
# .env
PSQL_USER=postgres
# PSQL_PASSWORD=tomas221999
JWT_SECRET=
AWS_ACCESS_KEY_ID=<insert key>
AWS_SECRET_ACCESS_KEY=<insert key>
S3_BUCKET=<bucket name>
AWS_REGION=<region>
````

