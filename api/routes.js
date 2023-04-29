const mongoose = require("mongoose");
const fs = require("fs");
const index_ = require("./index.js");
const schemas = require("./schemas.js")
const token_gen = require("random-token")
async function sha256(message) {
    // encode as UTF-8
    const msgBuffer = new TextEncoder().encode(message);                    
    // hash the message
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
    // convert ArrayBuffer to Array
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    // convert bytes to hex string                  
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}

async function checkToken(token){
    if(Math.round(Date.now() / 1000) - token < 2591999){
        return true;
    }else{
        return false;
    }
}

module.exports = {
    main: async function(db_ip, db_port, db_password, db_username, db_name, verify_cert){
        try{
            
            await mongoose.connect("mongodb://" + db_username + ":" + db_password + "@" + db_ip + ":" + db_port + "/" + db_name, { ssl: true , sslValidate: verify_cert}).catch(error => {
                console.log("Encountered an error connecting to the database!")
                throw(error)
            })
            if(verify_cert){
                console.log("Connected to " + db_name + "with SSL: VERIFIED")
            }else{
                console.log("Connected to " + db_name + " with SSL: UNVERIFIED")
            }
        }catch(err){
            console.log(err)
        }
    },

    create_user: async function(req, res){
        try{
            const user_model = mongoose.model("user", schemas.UserSchema)
            if(await user_model.findOne({username: await sha256(req.headers["username"])}).exec() == null){
                const securityToken_model = mongoose.model("security_token", schemas.SecurityTokenSchema)
                let key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50)
                while(await securityToken_model.findOne({token: await sha256(key)}) != null){
                    key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50) 
                }
                await user_model.create({username: await sha256(req.headers["username"]), password: await sha256(req.headers["password"]), remaining_uploads: 0})
                await securityToken_model.create({username: await sha256(req.headers["username"]), token: await sha256(key), creation_date: Math.round(Date.now() / 1000)})
                res.statusCode = 200;
                res.send(key)

            }else{
                res.statusCode = 409;
                res.send("USER ALREADY EXISTS");
            }
            
        }catch(err){
            console.log(err)
            res.statusCode = 400
            res.send()
        }
        
    },

    login: async function(req, res){
        try{
            const user_model = mongoose.model("user", schemas.UserSchema)
            if(await user_model.findOne({username: await sha256(req.headers["username"])}).exec() != null){
                if(await user_model.findOne({username: await sha256(req.headers["username"]), password: await sha256(req.headers["password"])}).exec() != null){
                    const securityToken_model = mongoose.model("security_token", schemas.SecurityTokenSchema)
                    let key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50)
                    while(await securityToken_model.findOne({token: await sha256(key)}) != null){
                        key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50) 
                    }
                    await securityToken_model.updateOne({username: await sha256(req.headers["username"])}, {token: await sha256(key), creation_date: Math.round(Date.now() / 1000)})
                    res.statusCode = 200
                    res.send(key)
                }else{
                    res.statusCode = 400
                    res.send("WRONG PASSWORD")
                }
            }else{
                res.statusCode = 400;
                res.send("USER DOESN'T EXIST");
            }
        }catch(err){
            console.log(err)
            res.statusCode = 400
            res.send("error")
        }
    },
    
    place_order: async function(req,res){
        try{
            const user_model = mongoose.model("user", schemas.UserSchema)
            const order_model = mongoose.model("order", shemas.OrderSchema)
            const security_token_model = mongoose.model("security_token", schemas.SecurityTokenSchema)
            await security_token_model.findOne({token: req.headers["authorization"]}, (err, result) => {
                if (err) {
                    console.error(err);
                    throw err;
                } else {
                    if(checkToken(result.creation_date)){
                        order_model.create({user: result.username, date: Math.round(Date.now() / 1000), file_ids: res.headers["file_ids"].split(",")})
                    }
                }
            })
        }catch(err){
            console.log(err)
            res.statusCode = 400
            res.send()
        }
    },
    upload: async function(req,res){
        try{
            console.log("File upload requested")
            let sampleFile;
            let uploadPath;

            if (!req.files || Object.keys(req.files).length === 0) {
                console.log("No files were uploaded.")
                return res.status(400).send('No files were uploaded.');
            }
            // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
            sampleFile = req.files.file;
            let key = await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50)
            while(await fs.existsSync("/uploads/" + key)){
                key = await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50) 
            }
            uploadPath = __dirname + '/uploads/' + key;

            // Use the mv() method to place the file somewhere on your server
            sampleFile.mv(uploadPath, function(err) {
                if (err){
                    console.log(err)
                    return res.status(400).send(err);
                }
                
                console.log("File uploaded!");
                res.status(200).send(key);
            });
        }catch(err){
            console.log(err)
        }
    },
    place_order: async function(req,res){
        try{
            res.sendFile("/uplaods/" + req.headers["file_id"])
        }catch(err){
            console.log(err);
            res.send(400)
        }
    },
    upload_design: async function(req, res){

    },
    
}


