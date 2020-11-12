const functions = require('firebase-functions');
const app = require('express')(); //initializing the app
const bodyParser = require('body-parser');
const AppMail = require("./utils/email");
const {fileParser} = require('express-multipart-file-parser');

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

exports.createAgentRequest = functions.firestore
    .document("users/{id}")
    .onUpdate(async (change, context) => {
        // Get an object with the current document value.
        const before = change.before.data();
        const data = change.after.data();

        if (!before.passport || !data.passport) return null;

        if (!before.passport.approved && data.passport.approved) { // just approved
            // update level
            await change.after.ref.update({
                level: 2
            });
            // notify user via email
            return AppMail.sendEmail(data.email, 'KYC Level 2 Approved', 'Your uploaded passport has been approved');
        }
        return null;
    });
