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
    OrderSchema: mongoose.Schema({//currently is useless
        user: "string",
        date: "string",
        order_id: "string",
        shipping_method: "Number",
        send_shipping_notification: "boolean",
        country: "string",
        region: "string",
        adress1: "string",
        adress2: "string",
        city: "string",
        zip_code: "string",
        printify_order_id: "string",
    }),
    FileTrackerSchema: mongoose.Schema({
        file_id: "string",
        author: "string",
        date: "string",
        file_type: "string"
    }),
    DesignSchema: mongoose.Schema({
        author: "string",
        like_count: "number",
        print_provider_id: "string",
        blueprint_id: "string",
        creation_date: "string",
        properties: "string",
    }),
}
