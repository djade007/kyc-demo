const {admin, db, firebase} = require('../utils/admin');
const functions = require("firebase-functions");
const bcrypt = require("bcrypt");
const {validateSignUPData, validateLoginData} = require('../utils/helper');
const randtoken = require('rand-token');
const AppMail = require('../utils/email');

exports.signUp = async (req, res) => {
    const newUser = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        username: req.body.username,
        email: req.body.email,
        password: req.body.password,
        level: 0,
    };

    const {valid, errors, message} = validateSignUPData(newUser);

    if (!valid)//checking validation
        return res.status(400).json({
            message,
            errors,
        });


    let snapshot = await db.collection('users').where('email', '==', newUser.email).get();

    if (!snapshot.empty) {
        return res.status(400).json({message: 'The email address already exists'});
    }

    snapshot = await db.collection('users').where('username', '==', newUser.username).get();
    if (!snapshot.empty) {
        return res.status(400).json({message: 'The username already exists'});
    }

    newUser.password = await bcrypt.hash(newUser.password, 10);
    newUser.confirmedEmail = false;
    newUser.acessToken = randtoken.generate(32);

    newUser.emailToken = randtoken.generate(40);

    await db.collection('users').add(newUser);

    // send email
    try {
        const link = 'https://google.com/api/confirm?token=' + newUser.emailToken;
        const body = `
        <p>Visit <a href="${link}">${link}</a> to verify your email address</p>
        `;
        await AppMail.sendEmail(newUser.email, 'Email Confirmation', body);
    } catch (e) {
        functions.logger.log(e);
    }

    return res.status(201).json({message: 'User Created Successfully'})
}

exports.signIn = async (req, res) => {
    const user = {
        email: req.body.email,
        password: req.body.password
    }

    const {valid, errors} = validateLoginData(user);
    if (!valid) return res.status(400).json({message, errors});

    // const docs = await db.collection('users').get();
    // console.log(docs.docs.map((e) => e.data().email));
    // console.log(user.email);
    const snapshot = await db.collection('users').where('email', '==', user.email).get();

    if (snapshot.empty) {
        return res.status(400).json({
            message: 'Email address not found'
        });
    }

    const data = snapshot.docs[0].data();

    try {
        await bcrypt.compare(user.password, data.password);
    } catch (e) {
        return res.status(400).json({
            message: 'Invalid password'
        });
    }

    if (!data.confirmedEmail) {
        return res.status(400).json({
            message: 'Please confirm your email address'
        });
    }

    return res.status(200).json({
        message: 'Success',
        data: {
            accessToken: data.accessToken,
        }
    });
}

exports.confirmEmail = async (req, res) => {
    const token = req.query.token;

    if (!token) {
        return res.status(400).send('Token required');
    }

    const snapshot = await db.collection('users').where('emailToken', '==', token).get();

    if (snapshot.empty) {
        return res.status(400).send('Invalid confirmation token');
    }

    await snapshot.docs[0].ref.update({
        confirmedEmail: true,
        emailToken: '',
    });


    return res.status(200).send('<h3>Email confirmation successful</h3>');
}

exports.getMe = async (req, res) => {
    const token = req.get('Access-Token');

    if (!token) {
        return res.status(400).send({message: 'Access token required'});
    }

    const snapshot = await db.collection('users').where('accessToken', '==', token).get();

    if (snapshot.empty) {
        return res.status(400).json({
            message: 'Invalid Access token'
        });
    }

    const data = snapshot.docs[0].data();

    return res.status(200).json({
        message: 'Successful',
        data: {
            user: {
                firstName: data.firstName,
                lastName: data.lastName,
                email: data.email,
                level: data.level,
            }
        }
    });
}
