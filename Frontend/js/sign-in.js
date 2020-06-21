const username = document.getElementById('username');
let usernameTouched = false;
const password = document.getElementById('password');
let passwordTouched = false;
const signInUsername = document.getElementById('sign-in-username');
const signInPassword = document.getElementById('sign-in-password');

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
});

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

    if (!passwordValidation.isValid) {
        if (passwordValidation.errors.required) {
            removeErrorInputs('input-error-password', signInPassword);
            error = createErrorInput(passwordValidation.errors.required, 'password');
        }
        else if (passwordValidation.errors.minLength) {
            removeErrorInputs('input-error-password', signInPassword);
            error = createErrorInput(passwordValidation.errors.minLength, 'password');
        }
        else if (passwordValidation.errors.maxLength) {
            removeErrorInputs('input-error-password', signInPassword);
            error = createErrorInput(passwordValidation.errors.maxLength, 'password');
        }
    } else {
        if (e.type !== 'blur') {
            removeErrorInputs('input-error-password', signInPassword);
        }
    }

    if (error != null) {
        signInPassword.appendChild(error);
    }
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
 * @param {"username" | "password"} type
 */
function createErrorInput(text, type) {
    const error = document.createElement('p');
    error.classList.add('input-error');

    if (type === 'username') {
        error.classList.add('input-error-username');
    }
    else if (type === 'password') {
        error.classList.add('input-error-password');
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