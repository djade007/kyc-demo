const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();


/*const serviceAccount = require('../credentials/firebase.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});*/

module.exports = {admin, db};