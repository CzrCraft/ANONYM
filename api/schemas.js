const mongoose = require("mongoose")

module.exports = {
    UserSchema: mongoose.Schema({
        username: "string",
        first_name: "string",
        last_name: "string",
        phone: "string",
        password: "string",
        remaining_uploads: "number"
    }),
    SecurityTokenSchema: mongoose.Schema({
        username: "string",
        token: "string",
        creation_date: "string"
    }),
    // OrderSchema: mongoose.Schema({
    //     user: "string",
    //     date: "string",
    //     order_id: "string",
    //     shipping_method: "int",
    //     send_shipping_notification: "bool",
    //     country: "string",
    //     region: "string",
    //     adress1: "string",
    //     adress2: "string",
    //     city: "string",
    //     zip_code: "string",
    //     printify_order_id: "string",
    // })
}
