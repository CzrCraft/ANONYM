const mongoose = require("mongoose");
const fs = require("fs");
const index_ = require("./index.js");
const schemas = require("./schemas.js")
const token_gen = require("random-token")
const crypto = require("crypto")
const path = require('path');
const https = require('https');
const got = require('got');

let security_token_valability_s = 0;
let uploadDir = "/";

let printifyApiToken = "";
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
    try{
        let securityToken_model = mongoose.model("security_token", schemas.SecurityTokenSchema);
        let token_result = await securityToken_model.findOne({token: await sha256(token)});
        if(token_result != null){
            if(Math.round(Date.now() / 1000) - token_result.creation_date < security_token_valability_s){
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }catch(err){
        console.log(err);
    }
}

async function getUserFromToken(token){
    try{
        let securityTokenModel = mongoose.model("security_token", schemas.SecurityTokenSchema);
        // check if token can be found inside the database
        if(await securityTokenModel.findOne({token: await sha256(token)}).exec() == null){
            return "COULDN'T FIND TOKEN"
        }else{
            let result = "INVALID_TOKEN";
            //get the user from said result
            result = (await securityTokenModel.findOne({token: await sha256(token)}).exec()).username;
            return result;
        }
    }catch(err){
        console.log(err);
    }
}

module.exports = {
    main: async function(db_ip, db_port, db_password, db_username, db_name, verify_cert, security_token_valability, fUploadDir, printifyToken){
        try{
            uploadDir = fUploadDir; // fUploadDir == File Upload Directory
            security_token_valability_s = security_token_valability;
            printifyApiToken = printifyToken
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
            if(await user_model.findOne({username: req.headers["username"]}).exec() == null){
                const securityToken_model = mongoose.model("security_token", schemas.SecurityTokenSchema)
                let key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50)
                while(await securityToken_model.findOne({token: await sha256(key)}) != null){
                    key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50) 
                }
                await user_model.create({username: req.headers["username"], password: await sha256(req.headers["password"]), remaining_uploads: 0})
                await securityToken_model.create({username: req.headers["username"], token: await sha256(key), creation_date: Math.round(Date.now() / 1000)})
                res.statusCode = 200;
                res.send(key)

            }else{
                res.statusCode = 400;
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
            if(await user_model.findOne({username: req.headers["username"]}).exec() != null){
                if(await user_model.findOne({username: req.headers["username"], password: await sha256(req.headers["password"])}).exec() != null){
                    const securityToken_model = mongoose.model("security_token", schemas.SecurityTokenSchema)
                    let key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50)
                    while(await securityToken_model.findOne({token: await sha256(key)}) != null){
                        key = await token_gen.create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50) 
                    }
                    await securityToken_model.updateOne({username: req.headers["username"]}, {token: await sha256(key), creation_date: Math.round(Date.now() / 1000)})
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
    // ik the names i used are really confusing
    // i'l try to stop using underline char
    resetPassword: async function(req, res, token){
        try {
            const userModel = mongoose.model("user", schemas.UserSchema)
            const securityTokenModel = mongoose.model("security_token", schemas.SecurityTokenSchema)
            let securityTokenRes = await securityTokenModel.findOne({ token: await sha256(token) }).exec()
            if (securityTokenRes != null) {
                userModel.updateOne({ username: securityTokenRes["username"] }, { password: await sha256(req.headers["password"]) }).exec()
                res.sendStatus(200)
            } else {
                res.sendStatus(400);
            }
        }catch(err){
            console.log(err)
            res.statusCode = 400
            res.send("error")
        }
    },
    logout: async function(req, res, token){
        try {
            // set token to something random so that it isn't useable anymore
            const securityTokenModel = mongoose.model("security_token", schemas.SecurityTokenSchema)
            securityTokenModel.updateOne({ token: await sha256(token) }, {token: await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(100)}).exec()
            res.sendStatus(200)
        }catch(err){
            console.log(err)
            res.statusCode = 400
            res.send("error")
        }
    },
    
    upload: async function(req,res, raw_token){
        try{
            console.log("File upload requested")
            let sampleFile;
            let uploadPath;
            let fileTrackerModel = mongoose.model("fileTracker", schemas.FileTrackerSchema)
            if (!req.files || Object.keys(req.files).length === 0) {
                console.log(req.body);
                console.log("No files were uploaded.")
                return res.status(400).send('No files were uploaded.');
            }
            // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
            sampleFile = req.files.file;
            let key = await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50)
            while(await fs.existsSync("/uploads/" + key)){
                key = await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(50) 
            }
            uploadPath = __dirname + '/uploads/' + key + "." + sampleFile.name.split(".")[1];

            // Use the mv() method to place the file somewhere on your server
            let user_hash = await getUserFromToken(req.headers["token"]);
            if(user_hash != "INVALID_TOKEN"){
                fileTrackerModel.create({author: await getUserFromToken(raw_token), file_id: key, file_type: sampleFile.name.split(".")[1], date: Math.round(Date.now() / 1000)})
                sampleFile.mv(uploadPath, async function(err) {
                    if (err){
                        console.log(err)
                        res.status(400).send("error");
                    }else{
                        console.log("File uploaded!");
                        res.status(200).send(key);
                    }
                })
            }else{
                res.status(400).send("INVALID TOKEN");
            }
            
        }catch(err){
            console.log(err)
        }
    },
    get_file: async function(req, res){
        try{
            const reading_options = {
                root: path.join(__dirname)
            };
            let fileTrackerModel = mongoose.model("fileTracker", schemas.FileTrackerSchema)
            let fileTracker = await fileTrackerModel.findOne({file_id: req.params.file_id}).exec()
            if(fileTracker != null){
                res.status(200).sendFile(uploadDir + fileTracker.file_id + "." + fileTracker.file_type, reading_options, function(err){
                    if(err){
                        console.log(err);
                    }
                })
            }
        }catch(err){
            res.status(400)
            console.log(err);
        }
    },
    auth_handler: async function (req, res, route_func, route_name) {
        console.log("----------------------------");
        console.log("Verification attepmted for " + route_name);
        console.log("from IP: " + req.ip)
        try {
            if (await checkToken(req.headers.authorization.split(" ")[1])) {
                console.log("Token was successfully verified: " + req.headers.authorization.split(" ")[1])
                route_func(req, res, req.headers.authorization.split(" ")[1]);
            } else {
                console.log("Token was not successfully verified: " + req.headers.authorization.split(" ")[1])
                res.status(400).send("INVALID TOKEN");
            }
        } catch (err) {
            console.log(err);
            res.sendStatus(400);
        }
    },

    get_blueprints: async function(req, response, token){
        try{
            let result = "";
            await https.request({
                host: "api.printify.com", 
                method: "GET", 
                path: "/v1/catalog/blueprints.json", 
                headers: {
                    "Authorization": "Bearer " + printifyApiToken
                }},
                async (res) =>  {
                    await res.on("data", function(chunk) {
                        result += chunk;
                    });
                    res.on("end", function(){
                        response.statusCode = 200;
                        response.send(result);
                    })
                }).end();
        }catch(err){
            response.send(500);
            console.log(err);
        }
    },
    
    upload_design: async function(req, res, token){
        try {
            let securityTokenModel = mongoose.model("security_token", schemas.SecurityTokenSchema);
            let designModel = mongoose.model("design", schemas.DesignSchema)
            let author_name = (await securityTokenModel.findOne({ token: await sha256(token) }).exec()).username;
            let print_provider = req.headers["print_provider"]
            let blueprint = req.headers["blueprint_id"]
            let variant_id = req.headers["variant_id"]
            let designName = req.headers["design_name"]
            let thumnbnail_id = req.headers["thumbnail"]
            let design_creation_date = Math.round(Date.now() / 1000)
            let design_properties = JSON.parse(JSON.stringify(req.body.properties))
            let designID = await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(100)
            while ((await designModel.findOne({ design_id: designID }).exec()) != null) {
                designID = await require("random-token").create('abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')(100)
            }
            let result = await designModel.create({liked_by: "", design_id: designID, thumbnail_id: thumnbnail_id, designName: designName, author: author_name, like_count: 0, print_provider_id: print_provider, blueprint_id: blueprint, creation_date: design_creation_date, properties: design_properties, variant_id: variant_id})
            if (result != null) {
                res.sendStatus(200);
            }else{
                res.sendStatus(400);
            }
        }catch(err){
            res.sendStatus(500)
            console.log(err);
        }
    },

    get_designs: async function(req, res, token){
        try{
            let designModel = mongoose.model("design", schemas.DesignSchema);
            let result = await designModel.find({}, "-_id -print_provider_id -__v -print_provider_id -blueprint_id -variant_id -creation_date").sort({like_count: -1}).exec()
            if(result != null){
                res.status = 200;
                res.send(result);
            }else{
                res.sendStatus(500);
            }
        }catch(err){
            res.sendStatus(500);
            console.log(err);
        }
    },
    search_designs: async function(req, res, token){
        try {
            if (req.headers["query"] == "GET_ALL") {
                let designModel = mongoose.model("design", schemas.DesignSchema);
                let result = await designModel.find({}, "-_id -print_provider_id -__v -print_provider_id -blueprint_id -variant_id -creation_date").sort({like_count: -1}).exec()
                if(result != null){
                    res.status = 200;
                    res.send(result);
                }else{
                    res.sendStatus(500);
                }
            } else {
                let designModel = mongoose.model("design", schemas.DesignSchema);
                const regexPattern = new RegExp("^" + req.headers["query"]);
                let result = await designModel.find({designName: regexPattern}, "-_id -print_provider_id -__v -print_provider_id -blueprint_id -variant_id -creation_date").sort({like_count: -1}).exec()
                if(result != null){
                    res.status = 200;
                    res.send(result);
                }else{
                    res.sendStatus(400);
                }
            }
        }catch(err){
            res.sendStatus(500);
            console.log(err);
        }
    },
    get_design: async function(req, res, token){
        try{
            let designModel = mongoose.model("design", schemas.DesignSchema);
            let designID = req.params.designID
            let result = await designModel.findOne({design_id: designID}, "-_id -__v").exec()
            if(result != null){
                res.status = 200;
                res.send(result);
            }else{
                res.sendStatus(500);
            }
        }catch(err){
            res.sendStatus(500);
            console.log(err);
        }
    },
    like_design: async function(req, res, token){
        try{
            let designModel = mongoose.model("design", schemas.DesignSchema);
            let security_token = mongoose.model("security_token", schemas.SecurityTokenSchema)
            let designID = req.params.design_id
            let result = await designModel.findOne({ design_id: designID }, "-_id -author -designName -thumbnail_id -print_provider_id -blueprint_id -variant_id -creation_date -properties").exec()
            if (result != null) {
                let likedBy = result["liked_by"].split(",");
                let tokenResult = await security_token.findOne({token: await sha256(token)}, "-_id -__v").exec()
                if (tokenResult != null) {
                    if (likedBy == "") {
                        await designModel.updateOne({ design_id: designID }, { like_count: parseInt(result["like_count"]) + 1, liked_by: (result["liked_by"] + "," + tokenResult["username"]) }).exec()
                        res.sendStatus(200);
                    } else {
                        if (!likedBy.includes(tokenResult["username"])) {
                            await designModel.updateOne({ design_id: designID }, { like_count: parseInt(result["like_count"]) + 1, liked_by: (result["liked_by"] + "," + tokenResult["username"]) }).exec()
                            res.sendStatus(200);
                        } else {
                            res.sendStatus(400);
                        }
                    }
                } else {
                    res.sendStatus(400);
                }
            } else {
                res.status = 400;
                res.send("DESIGN NOT FOUND")
            }
        }catch(err){
            res.sendStatus(500);
            console.log(err);
        }
    },
    dislike_design: async function(req, res, token){
        try{
            let designModel = mongoose.model("design", schemas.DesignSchema);
            let security_token = mongoose.model("security_token", schemas.SecurityTokenSchema)
            let designID = req.params.design_id
            let result = await designModel.findOne({ design_id: designID }, "-_id -author -designName -thumbnail_id -print_provider_id -blueprint_id -variant_id -creation_date -properties").exec()
            if (result != null) {
                let likedBy = result["liked_by"].split(",");
                let tokenResult = await security_token.findOne({token: await sha256(token)}, "-_id -__v").exec()
                if (tokenResult != null) {
                    if (likedBy == "") {
                        res.sendStatus(400);
                    } else {
                        if (likedBy.includes(tokenResult["username"])) {
                            await designModel.updateOne({ design_id: designID }, { like_count: parseInt(result["like_count"]) - 1, liked_by: (result["liked_by"].replace("," + tokenResult["username"], "")) }).exec()
                            res.sendStatus(200);
                        } else {
                            res.sendStatus(400);
                        }
                    }
                } else {
                    res.sendStatus(400);
                }
            } else {
                res.status = 400;
                res.send("DESIGN NOT FOUND")
            }
        }catch(err){
            res.sendStatus(500);
            console.log(err);
        }
    },
    get_blueprint: async function (req, response, token) {
        try{
            let result = "";
            await https.request({
                host: "api.printify.com", 
                method: "GET", 
                path: "/v1/catalog/blueprints/" + req.headers.printify_id+ ".json", 
                headers: {
                    "Authorization": "Bearer " + printifyApiToken
                }},
                async (res) =>  {
                    await res.on("data", function(chunk) {
                        result += chunk;
                    });
                    res.on("end", function(){
                        response.statusCode = 200;
                        response.send(result);
                    })
                }).end();
        }catch(err){
            response.send(500);
            console.log(err);
        }
    },
    get_variants: async function (req, response, token) {
        // disabling get_variants returning all of the varitants because
        // it would require extra logic checking valid variants
        // which also takes time
        var enabled = false;
        if (enabled) {
            try {
                const httpResponse1 = await got.get("https://api.printify.com/v1/catalog/blueprints/" + req.headers.printify_id + "/print_providers.json", {headers: { "Authorization": "Bearer " + printifyApiToken }})
                let parsedResult = await JSON.parse(httpResponse1.body);
                let resultingResponse = [];
                // get every print provider's variants and compile them into one big list.
                for(const element of parsedResult){
                    const httpResponse2 = await got.get("https://api.printify.com/v1/catalog/blueprints/" + req.headers.printify_id + "/print_providers/" + element["id"] + "/variants.json", { headers: { "Authorization": "Bearer " + printifyApiToken, "show-out-of-stock": "0"} })
                    let parsedResult2 = await JSON.parse(httpResponse2.body);
                    for(const element2 of parsedResult2["variants"]) {
                        // response is gonna be [id, color, size, canPrintOnTheFront, canPrintOnTheBack, frontHeight, frontWidth, backHeight, backWidth, printProviderId]
                        // the canPrintOnTheFront//TheBack are gonna be booleans
                        let frontPlaceholder;
                        let backPlaceholder;
                        // check if you can print on the front and back
                        let doesFront = false;
                        let doesBack = false;

                        // get the front and back max height and width for printing
                        for(const element3 of element2["placeholders"]){
                            if (element3["position"] == "front") {
                                frontPlaceholder = element3
                                doesFront = true
                            } else if(element3["position"] == "back"){
                                backPlaceholder = element3;
                                doesBack = true
                            }
                        }
                        if (doesFront) {
                            if (doesBack) {
                                await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], true, true, frontPlaceholder["height"], frontPlaceholder["width"], backPlaceholder["height"], backPlaceholder["width"], element["id"]])
                            } else {
                                await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], true, false, frontPlaceholder["height"], frontPlaceholder["width"], element["id"]])
                            }
                        } else {
                            if (doesBack) {
                                await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], false, true, backPlaceholder["height"], backPlaceholder["width"], element["id"]])
                            } else {
                                await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], false, false, element["id"]])
                            }
                        }
                    };
                };
                response.status(200).send(resultingResponse);
            } catch (err) {
                console.log(err);
            }
        } else {
            try {
                const httpResponse1 = await got.get("https://api.printify.com/v1/catalog/blueprints/" + req.headers.printify_id + "/print_providers.json", {headers: { "Authorization": "Bearer " + printifyApiToken }})
                let parsedResult = await JSON.parse(httpResponse1.body);
                let resultingResponse = [];
                // get the first print provider's variants and compile them into one big list.
                let element = parsedResult[0];
                const httpResponse2 = await got.get("https://api.printify.com/v1/catalog/blueprints/" + req.headers.printify_id + "/print_providers/" + element["id"] + "/variants.json", { headers: { "Authorization": "Bearer " + printifyApiToken, "show-out-of-stock": "0"} })
                let parsedResult2 = await JSON.parse(httpResponse2.body);
                for(const element2 of parsedResult2["variants"]) {
                    // response is gonna be [id, color, size, canPrintOnTheFront, canPrintOnTheBack, frontHeight, frontWidth, backHeight, backWidth, printProviderId]
                    // the canPrintOnTheFront//TheBack are gonna be booleans
                    let frontPlaceholder;
                    let backPlaceholder;
                    // check if you can print on the front and back
                    let doesFront = false;
                    let doesBack = false;

                    // get the front and back max height and width for printing
                    for(const element3 of element2["placeholders"]){
                        if (element3["position"] == "front") {
                            frontPlaceholder = element3
                            doesFront = true
                        } else if(element3["position"] == "back"){
                            backPlaceholder = element3;
                            doesBack = true
                        }
                    }
                    if (doesFront) {
                        if (doesBack) {
                            await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], true, true, frontPlaceholder["height"], frontPlaceholder["width"], backPlaceholder["height"], backPlaceholder["width"], element["id"]])
                        } else {
                            await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], true, false, frontPlaceholder["height"], frontPlaceholder["width"], element["id"]])
                        }
                    } else {
                        if (doesBack) {
                            await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], false, true, backPlaceholder["height"], backPlaceholder["width"], element["id"]])
                        } else {
                            await resultingResponse.push([element2["id"], element2["options"]["color"], element2["options"]["size"], false, false, element["id"]])
                        }
                    }
                };
                response.status(200).send(resultingResponse);
            } catch (err) {
                console.log(err);
            }
        }

    },
    getUsersFiles: async function (req, res, token) {
        try {
            let fileTrackerModel = mongoose.model("fileTracker", schemas.FileTrackerSchema)
            let security_token = mongoose.model("security_token", schemas.SecurityTokenSchema)
            let username = (await security_token.findOne({ token: await sha256(token) }).exec()).username
            let fileTracker = await fileTrackerModel.find({ author: username })
            let result = [];
            for (const file of fileTracker) {
                result.push(file.file_id);
            }
            res.status = 200;
            res.send(result.toString());
        } catch (err) {
            console.log(err);
            res.sendStatus(400);
        }
    },
    ping: async function (req, res, token) {
        res.sendStatus(200);
    },
    get_username: async function (req, res, token) {
        try {
            let security_token = mongoose.model("security_token", schemas.SecurityTokenSchema)
            let tokenResult = await security_token.findOne({ token: await sha256(token) }, "-_id -__v").exec()
            res.status = 200;
            res.send(tokenResult["username"]);
        } catch (err) {
            console.log(err);
        }
    }
}


