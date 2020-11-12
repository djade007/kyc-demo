const {admin, db} = require('./utils/admin')
const functions = require('firebase-functions');
const app = require('express')(); //initializing the app
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

/*const firebase = require('firebase');
const serviceAccount = require('credentials/firebase.json');
firebase.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://kyc-damo.firebaseio.com"
}); // Initializing Firebase*/
const {signIn, signUp, confirmEmail, getMe} = require('./handlers/auth');

app.post('/register', signUp);
app.post('/login', signIn);
app.get('/confirm-email', confirmEmail);
app.get('/me', getMe);

exports.api = functions.https.onRequest(app);
