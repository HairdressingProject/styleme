const { showAlert } = require('./alert');

const ADMIN_URL = "https://styleme.best";
const API_URL = "https://api.styleme.best";

const signUpBtn = document.getElementById('sign-up-btn');
const givenName = document.getElementById('given-name');
const familyName = document.getElementById('family-name');
const username = document.getElementById('username');
const email = document.getElementById('email');
const password = document.getElementById('password');
const confirmPassword = document.getElementById('confirm-password');
let givenNameTouched = false;
let givenNameValid = false;
let familyNameValid = true;
let usernameTouched = false;
let usernameValid = false;
let emailTouched = false;
let emailValid = false;
let passwordTouched = false;
let passwordValid = false;
let confirmPasswordTouched = false;
let confirmPasswordValid = false;
const signUpGivenName = document.getElementById('sign-up-given-name');
const signUpFamilyName = document.getElementById('sign-up-family-name');
const signUpUsername = document.getElementById('sign-up-username');
const signUpEmail = document.getElementById('sign-up-email');
const signUpPassword = document.getElementById('sign-up-password');
const signUpConfirmPassword = document.getElementById('sign-up-confirm-password');

let passwordsMatch = false;

const signUpForm = document.getElementById('sign-up-form');

document.addEventListener('DOMContentLoaded', function () {

    givenName.addEventListener('focus', function () {
        if (!givenNameTouched) {
            givenNameTouched = true;
        }
    });

    givenName.addEventListener('input', validateGivenName);
    givenName.addEventListener('blur', validateGivenName);

    familyName.addEventListener('input', validateFamilyName);
    familyName.addEventListener('blur', validateFamilyName);


    username.addEventListener('focus', function () {
        if (!usernameTouched) {
            usernameTouched = true;
        }
    });

    username.addEventListener('input', validateUsername);
    username.addEventListener('blur', validateUsername);

    email.addEventListener('focus', function () {
        if (!emailTouched) {
            emailTouched = true;
        }
    });

    email.addEventListener('input', validateEmail);
    email.addEventListener('blur', validateEmail);

    password.addEventListener('focus', function () {
        if (!passwordTouched) {
            passwordTouched = true;
        }
    });

    password.addEventListener('input', validatePassword);
    password.addEventListener('blur', validatePassword);

    confirmPassword.addEventListener('focus', function () {
        if (!confirmPasswordTouched) {
            confirmPasswordTouched = true;
        }
    });

    confirmPassword.addEventListener('input', validateConfirmPassword);
    confirmPassword.addEventListener('blur', validateConfirmPassword);

    // signUpForm.addEventListener('submit', signUp);

    updateSignUpBtn();
});

/**
 * Enables or disables the sign in button depending on the status of input fields
 */
function updateSignUpBtn() {
    if (!givenNameTouched ||
        !usernameTouched ||
        !emailTouched ||
        !passwordTouched ||
        !confirmPasswordTouched
    ) {
        signUpBtn.setAttribute('disabled', true);
    }
    else {
        if (givenNameValid &&
            usernameValid &&
            emailValid &&
            passwordValid &&
            confirmPasswordValid &&
            passwordsMatch
        ) {
            signUpBtn.removeAttribute('disabled');
        }
        else {
            signUpBtn.setAttribute('disabled', true);
        }
    }
}

/**
 * Validates given name input
 * @param {Event} e 
 */
function validateGivenName(e) {
    const input = e.target.value;
    let error = null;

    const givenNameValidation = validateInput(input, {
        required: true,
        maxLength: 128
    });

    givenNameValid = givenNameValidation.isValid;

    if (!givenNameValidation.isValid) {
        if (givenNameValidation.errors.required) {
            removeErrorInputs('input-error-given-name', signUpGivenName);
            error = createErrorInput(givenNameValidation.errors.required, 'givenName');
        }
        else if (givenNameValidation.errors.maxLength) {
            removeErrorInputs('input-error-given-name', signUpGivenName);
            error = createErrorInput(givenNameValidation.errors.maxLength, 'givenName');
        }
    }
    else {
        if (e.type != 'blur') {
            removeErrorInputs('input-error-given-name', signUpGivenName);
        }
    }

    if (error != null) {
        signUpGivenName.appendChild(error);
    }

    updateSignUpBtn();
}

/**
 * Validates family name input
 * @param {Event} e 
 */
function validateFamilyName(e) {
    const input = e.target.value;
    let error = null;

    const familyNameValidation = validateInput(input, {
        required: false,
        maxLength: 128
    });

    familyNameValid = familyNameValidation.isValid;

    if (!familyNameValidation.isValid) {
        if (familyNameValidation.errors.maxLength) {
            removeErrorInputs('input-error-family-name', signUpFamilyName);
            error = createErrorInput(familyNameValidation.errors.maxLength, 'familyName');
        }
    }
    else {
        if (e.type != 'blur') {
            removeErrorInputs('input-error-family-name', signUpFamilyName);
        }
    }

    if (error != null) {
        signUpFamilyName.appendChild(error);
    }

    updateSignUpBtn();
}


/**
 * Validates username input
 * @param {Event} e 
 */
function validateUsername(e) {
    const input = e.target.value;
    let error = null;

    const usernameValidation = validateInput(input, {
        required: true,
        maxLength: 512
    });

    usernameValid = usernameValidation.isValid;

    if (!usernameValidation.isValid) {
        if (usernameValidation.errors.required) {
            removeErrorInputs('input-error-username', signUpUsername);
            error = createErrorInput(usernameValidation.errors.required, 'username');
        }
        else if (usernameValidation.errors.maxLength) {
            removeErrorInputs('input-error-username', signUpUsername);
            error = createErrorInput(usernameValidation.errors.maxLength, 'username');
        }
    }
    else {
        if (e.type != 'blur') {
            removeErrorInputs('input-error-username', signUpUsername);
        }
    }

    if (error != null) {
        signUpUsername.appendChild(error);
    }

    updateSignUpBtn();
}

/**
 * Validates email input
 * @param {Event} e 
 */
function validateEmail(e) {
    const input = e.target.value;
    let error = null;

    const emailValidation = validateInput(input, {
        required: true,
        maxLength: 512,
        email: true
    });

    emailValid = emailValidation.isValid;

    if (!emailValidation.isValid) {
        if (emailValidation.errors.required) {
            removeErrorInputs('input-error-email', signUpEmail);
            error = createErrorInput(emailValidation.errors.required, 'email');
        }
        else if (emailValidation.errors.maxLength) {
            removeErrorInputs('input-error-email', signUpEmail);
            error = createErrorInput(emailValidation.errors.maxLength, 'email');
        }
        else if (emailValidation.errors.email) {
            removeErrorInputs('input-error-email', signUpEmail);
            error = createErrorInput(emailValidation.errors.email, 'email');
        }
    }
    else {
        if (e.type != 'blur') {
            removeErrorInputs('input-error-email', signUpEmail);
        }
    }

    if (error != null) {
        signUpEmail.appendChild(error);
    }

    updateSignUpBtn();
}

/**
 * Validates password input
 * @param {Event} e 
 */
function validatePassword(e) {
    const input = e.target.value;
    let error = null;

    const passwordValidation = validateInput(input, {
        required: true,
        minLength: 6,
        maxLength: 512,
        match: confirmPassword
    });

    passwordValid = passwordValidation.isValid;

    if (!passwordValidation.isValid) {
        if (passwordValidation.errors.required) {
            if (!document.getElementById('password-required')) {
                removeErrorInputs('input-error-password', signUpPassword);
                error = createErrorInput(passwordValidation.errors.required, 'password', 'password-required');
            }
        }
        else if (passwordValidation.errors.minLength) {
            if (!document.getElementById('password-minlength')) {
                removeErrorInputs('input-error-password', signUpPassword);
                error = createErrorInput(passwordValidation.errors.minLength, 'password', 'password-minlength');
            }
        }
        else if (passwordValidation.errors.maxLength) {
            if (!document.getElementById('password-maxlength')) {
                removeErrorInputs('input-error-password', signUpPassword);
                error = createErrorInput(passwordValidation.errors.maxLength, 'password', 'password-maxlength');
            }
        }
        else if (passwordValidation.errors.match) {
            if (!document.getElementById('password-match')) {
                removeErrorInputs('input-error-password', signUpPassword);
                error = createErrorInput(passwordValidation.errors.match, 'password', 'password-match');
                passwordsMatch = false;
            }
        }
    } else {
        passwordsMatch = true;
        if (e.type !== 'blur') {
            removeErrorInputs('input-error-password', signUpPassword);
        }
    }

    if (error != null) {
        signUpPassword.appendChild(error);
    }

    updateSignUpBtn();

    if (passwordsMatch &&
        validateInput(confirmPassword.value, {
            required: true,
            minLength: 6,
            maxLength: 512,
        }).isValid) {
        // remove error message from the other input
        confirmPasswordValid = true;
        if (document.getElementById('confirm-password-match')) {
            removeErrorInputs('input-error-confirm-password', signUpConfirmPassword);
        }
    }
}

/**
 * Validates confirm password input
 * @param {Event} e 
 */
function validateConfirmPassword(e) {
    const input = e.target.value;
    let error = null;

    const confirmPasswordValidation = validateInput(input, {
        required: true,
        minLength: 6,
        maxLength: 512,
        match: password
    });

    confirmPasswordValid = confirmPasswordValidation.isValid;

    if (!confirmPasswordValidation.isValid) {
        if (confirmPasswordValidation.errors.required) {
            if (!document.getElementById('confirm-password-required')) {
                removeErrorInputs('input-error-confirm-password', signUpConfirmPassword);
                error = createErrorInput(confirmPasswordValidation.errors.required, 'confirmPassword', 'confirm-password-required');
            }
        }
        else if (confirmPasswordValidation.errors.minLength) {
            if (!document.getElementById('confirm-password-minlength')) {
                removeErrorInputs('input-error-confirm-password', signUpConfirmPassword);
                error = createErrorInput(confirmPasswordValidation.errors.minLength, 'confirmPassword', 'confirm-password-minlength');
            }
        }
        else if (confirmPasswordValidation.errors.maxLength) {
            if (!document.getElementById('confirm-password-maxlength')) {
                removeErrorInputs('input-error-confirm-password', signUpConfirmPassword);
                error = createErrorInput(confirmPasswordValidation.errors.maxLength, 'confirmPassword', 'confirm-password-maxlength');
            }
        }
        else if (confirmPasswordValidation.errors.match) {
            if (!document.getElementById('confirm-password-match')) {
                passwordsMatch = false;
                removeErrorInputs('input-error-confirm-password', signUpConfirmPassword);
                error = createErrorInput(confirmPasswordValidation.errors.match, 'confirmPassword', 'confirm-password-match');
            }
        }
    } else {
        passwordsMatch = true;
        if (e.type !== 'blur') {
            removeErrorInputs('input-error-confirm-password', signUpConfirmPassword);
        }
    }

    if (error != null) {
        signUpConfirmPassword.appendChild(error);
    }

    if (passwordsMatch &&
        validateInput(password.value, {
            required: true,
            minLength: 6,
            maxLength: 512,
        }).isValid) {
        passwordValid = true;
        // remove error message from the other input
        if (document.getElementById('password-match')) {
            removeErrorInputs('input-error-password', signUpPassword);
        }
    }

    updateSignUpBtn();
}

/**
 * Validates an input based on conditions
 * @param {string} input 
 * @param {{required?: boolean, minLength?: number, maxLength?: number, match?: HTMLElement, email?: boolean}} conditions
 */
function validateInput(input, { required, minLength, maxLength, match, email }) {
    let errors = {};
    let isValid = true;

    if (required) {
        if (input.trim().length < 1) {
            isValid = false;
            errors.required = 'This field is required';

            return { isValid, errors };
        }
    }

    if (minLength) {
        if (input.trim().length < minLength) {
            isValid = false;
            errors.minLength = `At least ${minLength} characters are required for this field`;

            return { isValid, errors };
        }
        else {
            isValid = true;
        }
    }

    if (maxLength) {
        if (input.length > maxLength) {
            isValid = false;
            errors.maxLength = `Up to ${maxLength} characters are allowed for this field`;

            return { isValid, errors };
        }
        else {
            isValid = true;
        }
    }

    if (match) {
        if (input !== match.value) {
            isValid = false;
            errors.match = 'Passwords do not match';

            return { isValid, errors }
        }
        else {
            isValid = true;
        }
    }

    if (email) {
        // RFC 2822 compliant
        if (!/[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/.test(input)) {
            isValid = false;
            errors.email = 'Invalid email format';

            return { isValid, errors };
        }
    }

    return { isValid, errors };
}
/**
 * Creates an error message (as "p")
 * @param {string} text 
 * @param {"givenName" | "familyName" | "email" | "username" | "password" | "confirmPassword"} inputType
 * @param {string} errorId
 */
function createErrorInput(text, inputType, errorId) {
    const error = document.createElement('p');
    error.classList.add('input-error');

    switch (inputType) {
        case 'givenName':
            error.classList.add('input-error-given-name');
            break;

        case 'familyName':
            error.classList.add('input-error-family-name');
            break;

        case 'username':
            error.classList.add('input-error-username');
            break;

        case 'email':
            error.classList.add('input-error-email');
            break;

        case 'password':
            error.classList.add('input-error-password');
            break;

        case 'confirmPassword':
            error.classList.add('input-error-confirm-password');
            break;

        default:
            return;
    }

    if (errorId) {
        error.id = errorId;
    }

    error.textContent = text;

    return error;
}

/**
 * Removes previously created error messages
 * @param {string} className 
 * @param {Node|Element} parent 
 */
function removeErrorInputs(className, parent) {
    const currentErrors = parent.getElementsByClassName(className);

    for (let i = 0; i < currentErrors.length; i++) {
        parent.removeChild(currentErrors[i]);
    }
}

/**
 * Runs when sign up form is submitted
 * @param {Event} e 
 */
/* async function signUp(e) {
    e.preventDefault();
    signUpBtn.setAttribute('disabled', true);
    const url = e.target.action;

    const formValid = (
        givenNameTouched &&
        usernameTouched &&
        emailTouched &&
        passwordTouched &&
        confirmPasswordTouched
    ) &&
        (
            givenNameValid &&
            familyNameValid &&
            usernameValid &&
            emailValid &&
            passwordValid &&
            confirmPasswordValid
        );

    if (formValid) {
        const { value: givenNameInput } = givenName;
        const { value: familyNameInput } = familyName;
        const { value: usernameInput } = username;
        const { value: emailInput } = email;
        const { value: passwordInput } = password;

        const data = {
            UserName: usernameInput,
            UserEmail: emailInput,
            FirstName: givenNameInput,
            LastName: familyNameInput,
            UserPassword: passwordInput,
            UserRole: "user"
        };

        const response = await fetch(url, {
            method: 'POST',
            mode: 'cors',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json',
                'Origin': ADMIN_URL
            },
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            const msg = await parseResponse(response);

            if (msg.errors) {
                const firstError = Object.keys(msg.errors)[0];
                showAlert('error', msg.errors[firstError][0]);
            }

            console.dir(msg);
        }
        else {
            // successfully signed in
            window.location.replace(`${ADMIN_URL}/database.php`);
        }
    }
    signUpBtn.removeAttribute('disabled');
} */

/**
 * Tries to parse HTTP responses as JSON
 * @param {Response} res 
 */
/* async function parseResponse(res) {
    try {
        const msg = await res.json();
        return msg;
    }
    catch (err) {
        console.log('could not parse response');
    }
} */