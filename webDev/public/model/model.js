const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/foodie', {
    useNewUrlParser: true,
    useUnifiedTopology: true
}, function(error) {
    if (error) {
        console.error('Unable to connect: ', error);
    } else {
        console.log('Connected to MongoDB');
    }
});
mongoose.set('useCreateIndex', true);

let Schema = mongoose.Schema;
let userSchema = new Schema({
    username: String,
    password: String,
}, {
    collection: 'users'
});



module.exports.User = mongoose.model('user', userSchema);