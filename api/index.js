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
  server.get('/api/ping', (req,res)=>{routes.auth_handler(req, res, routes.ping, "API_PING")})
  
  //          user handling
  server.get("/api/user/signup", (req,res) => {routes.create_user(req, res)})
  server.get("/api/user/login", (req, res) => { routes.login(req, res) })
  server.get("/api/user", (req,res) => {routes.auth_handler(req, res, routes.get_username, "GET_USERNAME")})
  server.post("/api/user/resetPassword", (req,res) => {routes.auth_handler(req, res, routes.resetPassword, "RESET_PASSWORD")})
  server.post("/api/user/logout", (req,res) => {routes.auth_handler(req, res, routes.logout, "LOGOUT_USER")})
  //          file handling
  server.post("/api/files/upload", (req,res) => {routes.auth_handler(req, res, routes.upload, "FILE_UPLOAD")})
  server.get("/api/files", (req,res) => {routes.auth_handler(req, res, routes.getUsersFiles, "FILE_GET_USERS")})
  server.get("/api/files/:file_id", (req,res) => {routes.get_file(req, res)})
  //          blueprint handling
  server.get("/api/catalog/blueprints", (req, res) => {routes.auth_handler(req, res, routes.get_blueprints, "GET_BLUEPRINTS")})
  server.get("/api/catalog/blueprint", (req, res) => { routes.auth_handler(req, res, routes.get_blueprint, "GET_SPECIFIC_BLUEPRINT") })
  server.get("/api/catalog/get_variants", (req,res) => {routes.auth_handler(req, res, routes.get_variants, "GET_BLUEPRINT_VARIANTS")})
  //          desgins handling
  server.post("/api/catalog/designs", (req,res) => {routes.auth_handler(req, res, routes.upload_design, "UPLOAD_DESIGN")})
  server.get("/api/catalog/designs", (req, res) => { routes.auth_handler(req, res, routes.get_designs, "GET_DESIGNS") })
  server.get("/api/catalog/designs/:designID", (req, res) => {routes.auth_handler(req, res, routes.get_design, "GET_SPECIFIC_DESIGN")})
  server.post("/api/catalog/design/popularity/:design_id", (req, res) => { routes.auth_handler(req, res, routes.like_design, "LIKE_DESIGN") })
  server.delete("/api/catalog/design/popularity/:design_id", (req, res) => {routes.auth_handler(req, res, routes.dislike_design, "DISLIKE_DESIGN")})
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

