import { redirect } from './redirect';

const restoreBtn = document.getElementById('btn-restore');

const originalFields = {
    username: document.getElementById('username').value,
    email: document.getElementById('email').value,
    firstName: document.getElementById('first_name').value,
    lastName: document.getElementById('last_name').value
};

redirect();
restoreBtn.addEventListener('click', restoreFields);

function restoreFields(e) {
    e.preventDefault();

    document.getElementById('username').value = originalFields["username"];
    document.getElementById('email').value = originalFields["email"];
    document.getElementById('first_name').value = originalFields["firstName"];
    document.getElementById('last_name').value = originalFields["lastName"];
    document.getElementById('password').value = '';
    document.getElementById('confirm-password').value = '';
}