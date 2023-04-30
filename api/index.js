const https = require("https");
const fs = require("fs");
// Import the express module
const express = require("express");
const fileUpload = require('express-fileupload');
const routes = require("./routes.js");
// Instantiate an Express application
const server = express();
server.use(express.json());
server.use(fileUpload())

port = 42069;
let configs = JSON.parse("{}");
function doneReading(){
    port = configs["server_settings"]["port"]
    https
      .createServer({
        key: fs.readFileSync("sslcert/server.key"),
        cert: fs.readFileSync("sslcert/server.crt"),
      },server)
      .listen(port, ()=>{
        console.log('server is running on port ' + port)
      });
    routes.main(configs["server_settings"]["database_settings"]["ip"], 
                configs["server_settings"]["database_settings"]["port"], 
                configs["server_settings"]["database_settings"]["password"], 
                configs["server_settings"]["database_settings"]["user"], 
                configs["server_settings"]["database_settings"]["name"],
                configs["server_settings"]["database_settings"]["verify_ssl_certificate"],
                configs["server_settings"]["security_token_valability"],
                configs["server_settings"]["upload_dir"],
                configs["printify"]["token"]);
    server.get('/api', (req,res)=>{res.send("Base dir of Stylr's API")})
    //          user handling
    server.get("/api/user/signup", (req,res) => {routes.create_user(req, res)})
    server.get("/api/user/login", (req,res) => {routes.login(req, res)})
    //          file handling
    server.post("/api/files/upload", (req,res) => {routes.auth_handler(req, res, routes.upload)})
    server.get("/api/files/:file_id", (req,res) => {routes.get_file(req, res)})
    
    server.get("/api/catalog/blueprints", (req,res) => {routes.get_blueprints(req, res)})
    
}
fs.readFile("config.json", "utf8", (err, jsonString) => {
    if (err) {
        console.log("Error reading config file: " , err);
        return;
    }
    try {
        configs = JSON.parse(jsonString);
        doneReading();
    } catch (err) {
        console.log("Error parsing JSON string:", err);
    }
});
// Create a NodeJS HTTPS listener on port 4000 that points to the Express app
// Use a callback function to tell when the server is created.

