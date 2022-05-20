# README
The CRUD api's are defined in the posts_controllers(controllers/api/posts_controller.rb).
Api's test cases written in the posts_spec.rb(spec/request/posts_spec.rb). The model test cases 
are written under the model directory(spec/models).
The authentication method  of API's written in the application controller.
Set the environment variables in the .env file. Related to the database configuration environment 
variables are define in the database.yml. 
When post is created image will upload to the s3 bucket of AWS. Related to s3 configuration
set the environment variables in the storage.yml.

Setup
* Database creation rails db:create
* Database migration rails db:migrate
* bundle install

To run the API locally, import the API's in the Postman from following URL
https://www.getpostman.com/collections/10dad6e8b7d3860cb7b1

The test cases run with the help of the this command
* bundle exec rspec

To view the documentation of the API's you can access from the following link

* http://localhost:3000/api/index.html

