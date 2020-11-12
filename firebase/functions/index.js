const {admin, db} = require('./utils/admin')
const functions = require('firebase-functions');
// const fileUpload = require('express-fileupload');
const app = require('express')(); //initializing the app
const bodyParser = require('body-parser');
const {fileParser} = require('express-multipart-file-parser');

/*app.use(fileUpload({
    limits: {fileSize: 10 * 1024 * 1024},
    useTempFiles: true,
    tempFileDir: '/tmp/'
}));*/

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

app.use(fileParser({
    rawBodyOptions: {
        limit: '15mb',  //file size limit
    },
    busboyOptions: {
        limits: {
            fields: 20   //Number text fields allowed
        }
    },
}))


const {signIn, signUp, confirmEmail, getMe, bvnVerification, mockBVN, passportVerification} = require('./handlers/auth');

app.post('/register', signUp);
app.post('/login', signIn);
app.get('/confirm-email', confirmEmail);
app.get('/me', getMe);
app.post('/verify-bvn', bvnVerification);
app.post('/mock-bvn', mockBVN);

app.post('/passport-verification', passportVerification);

exports.api = functions.https.onRequest(app);


