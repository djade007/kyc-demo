const {expect, should} = require("chai");
const admin = require("firebase-admin");
const bcrypt = require("bcrypt");
const randtoken = require('rand-token');


const supertest = require('supertest');
const sinon = require('sinon');

process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
const PROJECT_ID = 'kyc-test';

// Initialize the firebase-functions-test SDK using environment variables.
// These variables are automatically set by firebase emulators:exec
//
// This configuration will be used to initialize the Firebase Admin SDK, so
// when we use the Admin SDK in the tests below we can be confident it will
// communicate with the emulators, not production.
const test = require("firebase-functions-test")({
    projectId: PROJECT_ID,
});

// Import the exported function definitions from our functions/index.js file
const myFunctions = require("../index");
let adminInitStub, request;

const password = '12345678';
const hashedPassword = bcrypt.hashSync(password, 2);

let confirmedUser = {
    firstName: 'Tola',
    lastName: 'James',
    username: 'jones',
    email: 'jtt@djade.net',
    accessToken: randtoken.generate(32),
    emailToken: randtoken.generate(40),
    password: hashedPassword,
    confirmedEmail: true,
    level: 0,
};

let unconfirmedUser = {
    firstName: 'Tom',
    lastName: 'Jah',
    username: 'jah',
    email: 'jjh@djade.net',
    accessToken: randtoken.generate(32),
    emailToken: randtoken.generate(40),
    password: hashedPassword,
    confirmedEmail: false,
    level: 0,
};

describe("Unit tests", () => {
    before(async () => {
        adminInitStub = sinon.stub(admin, 'initializeApp');
        request = supertest(myFunctions.api);

        // store 2 test users
        await admin.firestore().doc('users/confirmed').set(
            confirmedUser
        );

        await admin.firestore().doc('users/un-confirmed').set(
            unconfirmedUser
        );
    });

    after(() => {
        adminInitStub.restore();
        test.cleanup();
    });


    it("tests registration validation", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.
        request
            .post('/register')
            .send({email: 'john@john.com'})
            .expect(400)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.message).to.contain('required')
                return done();
            });
    });

    it("can register users", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.
        const user = {
            firstName: 'Tola',
            lastName: 'James',
            username: 'john',
            email: 'jjc@djade.net',
            password: '12345678',
            test: true,
        };

        request
            .post('/register')
            .send(user)
            .expect(201)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.message).to.contain('Successfully')
                return done();
            });
    }).timeout(6000);

    it("cannot reuse email or username", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.
        const user = {
            firstName: 'JJB',
            lastName: 'TTT',
            username: confirmedUser.username,
            email: confirmedUser.email,
            password: '12345678'
        };

        request
            .post('/register')
            .send(user)
            .expect(400)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.message).to.contain('already exists')
                return done();
            });
    }).timeout(6000);

    it("confirmed users can login", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.
        const user = {
            email: confirmedUser.email,
            password: confirmedUser.password,
        };

        request
            .post('/login')
            .send(user)
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.data.accessToken).to.equal(confirmedUser.accessToken);
                return done();
            });
    }).timeout(6000);

    it("Unconfirmed users can not login", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.
        const user = {
            email: unconfirmedUser.email,
            password: unconfirmedUser.password,
        };

        request
            .post('/login')
            .send(user)
            .expect(400)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.message).to.contain('confirm your email');
                return done();
            });
    }).timeout(6000);

    it("Unconfirmed users can confirm emails", (done) => {
        request
            .get('/confirm-email?token=' + unconfirmedUser.emailToken)
            .send()
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.text).to.contain('confirmation successful');
                return done();
            });
    }).timeout(6000);

    it("can get user", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.

        request
            .get('/me')
            .set('Access-Token', confirmedUser.accessToken)
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.data.user.firstName).to.equals(confirmedUser.firstName);
                expect(res.body.data.user.lastName).to.equals(confirmedUser.lastName);
                expect(res.body.data.user.email).to.equals(confirmedUser.email);
                return done();
            });
    }).timeout(6000);

    it("can update bvn", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.

        request
            .post('/verify-bvn')
            .set('Access-Token', confirmedUser.accessToken)
            .send({
                'dob': '12/12/1980',
                'bvn': '12345'
            })
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.data.user.level).to.equals(1);
                return done();
            });
    }).timeout(6000);

    it("can mock bvn", (done) => {
        // Invoke function with our fake request and response objects. This will cause the
        // assertions in the response object to be evaluated.

        request
            .post('/mock-bvn')
            .send({
                'dob': '12/12/1986',
                'bvn': '12345'
            })
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.data.valid).to.equals(false);
                return done();
            });
    }).timeout(6000);

    it("can upload passport", (done) => {
        request
            .post('/passport-verification')
            .set('Access-Token', confirmedUser.accessToken)
            .set('Unit-Test', 'true')
            .attach('passport', 'test/image.jpg')
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                return done();
            });
    }).timeout(60000);
});
