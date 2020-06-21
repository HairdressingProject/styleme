const signInBtn = document.getElementById('sign-in-btn');
const username = document.getElementById('username');
let usernameTouched = false;
let usernameValid = false;
const password = document.getElementById('password');
let passwordTouched = false;
let passwordValid = false;
const signInUsername = document.getElementById('sign-in-username');
const signInPassword = document.getElementById('sign-in-password');

const signInForm = document.getElementById('sign-in-form');

document.addEventListener('DOMContentLoaded', function () {
    username.addEventListener('focus', function () {
        if (!usernameTouched) {
            usernameTouched = true;
        }
    });

    username.addEventListener('input', validateUsername);
    username.addEventListener('blur', validateUsername);

    password.addEventListener('focus', function () {
        if (!passwordTouched) {
            passwordTouched = true;
        }
    });

    password.addEventListener('input', validatePassword);
    password.addEventListener('blur', validatePassword);

    signInForm.addEventListener('submit', signIn);

    updateSignInBtn();
});

/**
 * Enables or disables the sign in button depending on the status of input fields
 */
function updateSignInBtn() {
    if (!usernameTouched || !passwordTouched) {
        signInBtn.setAttribute('disabled', true);
    } else {
        if (usernameValid && passwordValid) {
            signInBtn.removeAttribute('disabled');
        } else {
            signInBtn.setAttribute('disabled', true);
        }
    }
}

/**
 * Validates username/email input
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
            removeErrorInputs('input-error-username', signInUsername);
            error = createErrorInput(usernameValidation.errors.required, 'username');
        }
        else if (usernameValidation.errors.maxLength) {
            removeErrorInputs('input-error-username', signInUsername);
            error = createErrorInput(usernameValidation.errors.maxLength, 'username');
        }
    }
    else {
        if (e.type != 'blur') {
            removeErrorInputs('input-error-username', signInUsername);
        }
    }

    if (error != null) {
        signInUsername.appendChild(error);
    }

    updateSignInBtn();
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
        maxLength: 512
    });

    passwordValid = passwordValidation.isValid;

    if (!passwordValidation.isValid) {
        if (passwordValidation.errors.required) {
            if (!document.getElementById('password-required')) {
                removeErrorInputs('input-error-password', signInPassword);
                error = createErrorInput(passwordValidation.errors.required, 'password', 'password-required');
            }
        }
        else if (passwordValidation.errors.minLength) {
            if (!document.getElementById('password-minlength')) {
                removeErrorInputs('input-error-password', signInPassword);
                error = createErrorInput(passwordValidation.errors.minLength, 'password', 'password-minlength');
            }
        }
        else if (passwordValidation.errors.maxLength) {
            if (!document.getElementById('password-maxlength')) {
                removeErrorInputs('input-error-password', signInPassword);
                error = createErrorInput(passwordValidation.errors.maxLength, 'password', 'password-maxlength');
            }
        }
    } else {
        if (e.type !== 'blur') {
            removeErrorInputs('input-error-password', signInPassword);
        }
    }

    if (error != null) {
        signInPassword.appendChild(error);
    }

    updateSignInBtn();
}

/**
 * Validates an input based on conditions
 * @param {string} input 
 * @param {{required: boolean, minLength: number, maxLength: number}} conditions
 */
function validateInput(input, { required, minLength, maxLength }) {
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

    return { isValid, errors };
}
/**
 * Creates an error message (as "p")
 * @param {string} text 
 * @param {"username" | "password"} inputType
 * @param {string} errorId
 */
function createErrorInput(text, inputType, errorId) {
    const error = document.createElement('p');
    error.classList.add('input-error');

    if (inputType === 'username') {
        error.classList.add('input-error-username');
    }
    else if (inputType === 'password') {
        error.classList.add('input-error-password');
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

async function signIn(e) {
    e.preventDefault();
    const url = e.target.action;

    const formValid = usernameTouched && passwordTouched && usernameValid && passwordValid;

    if (formValid) {
        const { value: usernameInput } = username;
        const { value: passwordInput } = password;

        const data = { UserNameOrEmail: usernameInput, UserPassword: passwordInput };

        const response = await fetch(url, {
            method: 'POST',
            mode: 'cors',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json',
                'Origin': 'http://localhost:5500/'
            },
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            if (response.status === 401) {
                const msg = await parseResponse(response);

                // show errors
                if (msg.errors.authentication.length) {
                    showAlert('error', msg.errors.authentication[0]);
                }
            }
        }
        else {
            // successfully signed in
            window.location.replace('http://localhost:5500/database.html');
        }
    }
}

/**
 * Tries to parse HTTP responses as JSON
 * @param {Response} res 
 */
async function parseResponse(res) {
    try {
        const msg = await res.json();
        return msg;
    }
    catch (err) {
        console.log('could not parse response');
    }
}