# Stylr
https://youtu.be/vXdamGKVtsA
Team name: ANONYM

School: Scoala Gimnaziala Nr. 49

Teammates: Constantin Cezar Stefan

Technology: Flutter, NodeJS

Language: English

All in one platform for making and sharing custom clothing.
# API
It's API is secured with locally signed SSL Certificates. The users are securely stored in a MongoDB Database with an ssl certificate ensuring encripted communications and password protection for both the MongoDB Cluster and Database.


Requirements:
  * **MongoDB Enterprise edition**
  * **Node JS**
  
Installation:

  * First run "npm install" to install all the required dependencies.

  * Then run "npm install nodemon".

  * Then simply run "nodemon" to start the API, assuming the config file was edited right.

*Note that nodemon is simply for development porpouses.

  * For production enviroments install PM2 using "npm install pm2 -g"

  * And start the API using this command: "pm2 start api.js -i <core_nr>"
  
*More info can be found at: https://www.npmjs.com/package/pm2

List of commands:

    npm install
    npm install nodemon
    nodemon

Api should be configured in the config.json file, and port forwarding should be allowed if you were to host the api to the public.

MongoDB should be configured with an ssl certificate, acceptable ip classes set to 0.0.0.0 if using a seperate server, and a user and password be set on the server.

# APP
It's app is lightweight, and fast. Our only concern is to make this as straightforward as possible. It has a simple and clean UI.


Requirements:
 * **Dart**
 * **Flutter**

Before running/building it run "flutter pub get" to install all the required packages.


# Setting up

For easy installation of the build env use these commands in the base dir of the project:

    cd project_utillities
    setup_project.bat
Make sure that Flutter and NodeJS are installed properly before running.
