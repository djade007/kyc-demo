//for checking empty string or not
const isEmpty = (string) => {
    return string === undefined || string.trim() === '';
}
//for checking valid email address with regualr expression
const isEmail = (email) => {
    const regx = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$/;
    return Boolean(email.match(regx));
}
const isUsername = (username) => {
    const regx = /^[a-zA-Z0-9_]+$/;
    return Boolean(username.match(regx));
}
//for validating signup data
exports.validateSignUPData = (data) => {
    let errors = {};

    if (isEmpty(data.firstName)) {
        errors.firstName = "First name field is required"
    }

    if (isEmpty(data.lastName)) {
        errors.lastName = "First name field is required"
    }

    if (isEmpty(data.username)) {
        errors.username = "Username field is required"
    } else if (!isUsername(data.username)) {
        errors.username = 'Invalid username';
    }

    if (isEmpty(data.email)) {
        errors.email = "Email field is required"
    } else if (!isEmail(data.email)) {
        errors.email = "Must be valid email address";
    }

    if (isEmpty(data.password)) {
        errors.password = "Password is required";
    } else if (data.password.length < 8) {
        errors.password = "Password should be atleast 8 characters";
    }

    let message = '';
    const keys = Object.keys(errors);
    if (keys.length > 0) {
        // add the first error to message
        message = errors[keys[0]];
    }

    return {
        errors,
        message,
        valid: message === '',
    }
}
//for validating signin data
exports.validateLoginData = (data) => {
    let errors = {}
    if (isEmpty(data.email)) {
        errors.email = "Email filed is required"
    } else if (isEmpty(data.password)) {
        errors.password = "Password filed is required"
    } else if (!isEmail(data.email)) {
        errors.email = "Must be valid email address"
    }
    return {
        errors,
        valid: Object.keys(errors).length === 0
    }
}
