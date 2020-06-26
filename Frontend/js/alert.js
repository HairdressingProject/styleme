const existingAlert = document.getElementById('alert');

if (existingAlert) {
    const alertCloseBtn = document.getElementById('alert-close-btn');

    if (alertCloseBtn) {
        alertCloseBtn.addEventListener('click', dismissAlert);
    }
}

/**
 * Displays a dismissable alert message
 * @param {"error" | "success"} type 
 * @param {string} message 
 */
function showAlert(type, message) {
    // remove previous alerts first
    const existingAlert = document.getElementById('alert');

    if (existingAlert) {
        existingAlert.parentNode.removeChild(existingAlert);
    }

    const alertContainer = document.createElement('div');
    alertContainer.classList.add('alert');

    if (type === 'error') {
        alertContainer.classList.add('alert-error');
    } else if (type === 'success') {
        alertContainer.classList.add('alert-success');
    }

    alertContainer.id = 'alert';

    const msg = document.createElement('p');
    msg.classList.add('alert-message');
    msg.textContent = message;

    const closeBtn = document.createElement('button');
    closeBtn.classList.add('alert-close');
    closeBtn.id = 'alert-close-btn';

    const img = document.createElement('img');
    img.src = "/img/icons/close.svg";
    img.alt = "close";

    closeBtn.appendChild(img);
    alertContainer.appendChild(msg);
    alertContainer.appendChild(closeBtn);

    document.body.prepend(alertContainer);

    closeBtn.addEventListener('click', dismissAlert);
}

/**
 * Dismisses alert messages
 */
function dismissAlert() {
    const alertMsg = document.getElementById('alert');
    alertMsg.style.display = 'none';
}