const mongoose = require("mongoose")

module.exports = {
    UserSchema: mongoose.Schema({
        username: "string",
        password: "string",
        remaining_uploads: "number"
    }),
    SecurityTokenSchema: mongoose.Schema({
        username: "string",
        token: "string",
        creation_date: "string"
    }),
    OrderSchema: mongoose.Schema({
        user: "string",
        date: "string",
        file_ids: "array"
    })
}
