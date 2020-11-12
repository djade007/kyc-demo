const {admin, db} = require('../utils/admin');
const functions = require("firebase-functions");
const bcrypt = require("bcrypt");

const {validateSignUPData, validateLoginData, validateBvnData} = require('../utils/helper');
const randtoken = require('rand-token');
const AppMail = require('../utils/email');

const baseURL = 'https://us-central1-kyc-damo.cloudfunctions.net/api';

function userObject(data) {
    return {
        firstName: data.firstName,
        lastName: data.lastName,
        username: data.username,
        email: data.email,
        level: data.level,
    };
}

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
    newUser.accessToken = randtoken.generate(32);

    newUser.emailToken = randtoken.generate(40);

    await db.collection('users').add(newUser);

    // send email
    if (req.body.test !== true) {
        try {
            const link = `${baseURL}/confirm-email?token=${newUser.emailToken}`;
            const body = `
        <p>Visit <a href="${link}">${link}</a> to verify your email address</p>
        `;
            await AppMail.sendEmail(newUser.email, 'Email Confirmation', body);
        } catch (e) {
            functions.logger.log(e);
        }
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
            user: userObject(data),
        }
    });
}

exports.bvnVerification = async (req, res) => {
    const token = req.get('Access-Token');

    if (!token) {
        return res.status(400).send({message: 'Access token required'});
    }

    const formData = {
        bvn: req.body.bvn,
        dob: req.body.dob
    }

    const {valid, errors, message} = validateBvnData(formData);
    if (!valid) return res.status(400).json({message, errors});


    const snapshot = await db.collection('users').where('accessToken', '==', token).get();

    if (snapshot.empty) {
        return res.status(400).json({
            message: 'Invalid access token'
        });
    }

    let mock = validateBVN(formData);
    if (!mock.valid) {
        return res.status(400).json({
            message: "BVN is not valid"
        });
    }

    await snapshot.docs[0].ref.update({
        level: 1,
    });

    const user = await snapshot.docs[0].ref.get();

    return res.status(200).json({
        message: 'BVN verification successful',
        data: {
            user: userObject(user.data()),
        }
    });
}

const bucket = admin.storage().bucket('kyc-damo.appspot.com');

exports.passportVerification = async (req, res) => {
    const token = req.get('Access-Token');

    if (!token) {
        return res.status(400).send({message: 'Access token required'});
    }

    const snapshot = await db.collection('users').where('accessToken', '==', token).get();

    if (snapshot.empty) {
        return res.status(400).json({
            message: 'Invalid access token'
        });
    }

    let passport = req.files[0];

    if (!passport) {
        res.status(400).send('Passport file is required');
        return;
    }

    let passportPath = await uploadImageToStorage(passport);

    await snapshot.docs[0].ref.update({
        passport: {
            documentName: passportPath,
            approved: false,
        }
    });

    const user = await snapshot.docs[0].ref.get();

    return res.status(200).json({
        message: 'Passport uploaded successfully',
        data: {
            user: userObject(user.data()),
        }
    });
}

const uploadImageToStorage = (file) => {
    let prom = new Promise((resolve, reject) => {
        if (!file) {
            reject(new Error('No image file'));
        }
        let newFileName = randtoken.generate(10) + file.originalname; //unique name

        let fileUpload = bucket.file(newFileName);
        const blobStream = fileUpload.createWriteStream({
            metadata: {
                contentType: file.mimetype
            }
        });

        blobStream.on('error', (error) => {
            reject(new Error('Something is wrong! Unable to upload at the moment.'));
        });

        blobStream.on('finish', () => {
            const url = `https://storage.googleapis.com/${bucket.name}/${fileUpload.name}`; //image url from firebase server
            resolve(url);

        });

        blobStream.end(file.buffer);
    });
    return prom;
}

exports.mockBVN = async (req, res) => {
    const formData = {
        bvn: req.body.bvn,
        dob: req.body.dob
    }
    const {valid, errors, message} = validateBvnData(formData);
    if (!valid) return res.status(400).json({message, errors});

    return res.status(200).json({
        data: validateBVN(formData),
    });
}

function validateBVN(formData) {
    return {
        valid: formData.dob === '12/12/1980',
        dob: formData.dob,
        phoneNumber: '08097767799'
    };
}