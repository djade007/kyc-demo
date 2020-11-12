const nodemailer = require("nodemailer");
const credentials = require("../credentials/email");

let transporter = nodemailer.createTransport(credentials.credential);

exports.sendEmail = function (to, subject, body) {
    return null;
    const mailOptions = {
        from: `KYC-DEMO <${credentials.credential.auth.user}>`,
        to: to,
        subject: subject,
        html: body,
    };

    return transporter.sendMail(mailOptions);
}
