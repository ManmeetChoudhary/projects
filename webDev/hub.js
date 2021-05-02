let express = require('express');
const nodemailer = require('nodemailer');


let app = express();
var bodyParser = require('body-parser');

const session = require('express-session');
const { v4: uuidv4 } = require('uuid');
const bcrypt = require('bcryptjs');

const model = require('./public/model/model.js');
const e = require('express');


app.use(express.static('public'));
app.use(express.urlencoded({extended: false}));


app.use(session({
  genid: uuidv4,
  resave: false,
  saveUninitialized: false,
  // cookie: {secure: true},
  secret: '3230 examples typing fast need coffee'
}));

let http = require('http').createServer(app);
let io = require('socket.io')(http);

io.on('connection', function(socket){
  console.log('user connected');
  
  socket.on('disconnect', function() {
    console.log('user disconnected');
  });
});

app.get('/', function(request, response){
  response.sendFile(__dirname + '/public/Login.html');
});



app.post('/login', function(request, response) {


  model.User.find({username: request.body.loginUser, password: request.body.loginPass}).then(function(userList) {
      if (userList.length > 0) {
          // there is already a student with that sid
          response.sendFile(__dirname + '/public/store.html');
      } 
  });

});

app.post('/create', function(request, response) {
  
  console.log(request.body.createUser)
  console.log(request.body.createPass)
  let userData = {
    username: request.body.createUser,
    password: request.body.createPass, 
  };
  let newUser = new model.User(userData);
  newUser.save(function(error) {
      if (error) {
          console.error('Unable to add user:', error);
      } else {
          console.log('User added');
          response.sendFile(__dirname + '/public/store.html');
      }
  });
});

app.set('port', process.env.PORT || 3000);
app.listen(app.get('port'), function() {
    console.log(`Listening for requests on port ${app.get('port')}.`);
}); 






// app.post('/email', function(request, response) {

//     console.log(request.body.ingredientsInfo);
//     console.log(request.body.emailInfo);


// });



app.post('/email', function(request, response) {
  if(validateEmail(request.body.emailInfo)){
    nodemailer.createTestAccount((err, account) => {
      if (err) {
          console.error('Failed to create a testing account');
          console.error(err);
          return process.exit(1);
      }
    
      console.log('Credentials obtained, sending message...');
    
      // NB! Store the account object values somewhere if you want
      // to re-use the same account for future mail deliveries
    
      // Create a SMTP transporter object
      let transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 465,
        secure: true,
        auth: {
            user: 'foodies.uoit@gmail.com',
            pass: 'randyisgod'
        }
      });
    
    
      // Message object
      let message = {
  
          from: 'Foodies Eat Well! <foodies.uoit@gmail.com>',
    
          // Comma separated list of recipients
          to: request.body.emailInfo,
    
          // Subject of the message
          subject: 'Recipe: ' + request.body.hiddenName,
    
          // plaintext body
          // text: request.body.ingredientsInfo + request.body.instructionInfo,
  
          html: '<p>To make this recipie you need: <br></p>' + request.body.ingredientsInfo + '<p>\nInstructions:\n<p>' + request.body.instructionInfo,
    
          // list: {
          //     // List-Help: <mailto:admin@example.com?subject=help>
          //     help: 'admin@example.com?subject=help',
    
          //     // List-Unsubscribe: <http://example.com> (Comment)
          //     unsubscribe: [
          //         {
          //             url: 'http://example.com/unsubscribe',
          //             comment: 'A short note about this url'
          //         },
          //         'unsubscribe@example.com'
          //     ],
    
          //     // List-ID: "comment" <example.com>
          //     id: {
          //         url: 'mylist.example.com',
          //         comment: 'This is my awesome list'
          //     }
          // }
      };
    
      transporter.sendMail(message, (error, info) => {
          if (error) {
              console.log('Error occurred');
              console.log(error.message);
              return process.exit(1);
          }
    
          console.log('Message sent successfully!');
    
          // only needed when using pooled connections
          transporter.close();
      });
    });
    response.sendFile(__dirname + '/public/store.html');
    
  } else{
    console.log("not an actual email");
    response.sendFile(__dirname + '/public/store.html');
  }
  


});

function validateEmail(mail) 
{
 if (/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(mail))
  {
    return (true)
  }
    return (false)
}