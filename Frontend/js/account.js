const logoutLink = document.getElementById('logout');
const userName = document.getElementById('user-name');
const restoreBtn = document.getElementById('btn-restore');

const originalFields = {
    username: document.getElementById('username').value,
    email: document.getElementById('email').value,
    firstName: document.getElementById('first_name').value,
    lastName: document.getElementById('last_name').value
};

document.addEventListener('DOMContentLoaded', async function () {
    const id = await authenticate();

    if (id) {
        const { user } = await getUser(id) || { firstName: 'User' };
        userName.textContent = `${user.firstName} ${user.lastName || ""}`;
    }
    else {
        // not authenticated
        window.location.replace('/sign_in.php');
    }

    logoutLink.addEventListener('click', async function (e) {
        e.preventDefault();
        await logout();
    });

    restoreBtn.addEventListener('click', restoreFields);
});

function restoreFields(e) {
    e.preventDefault();

    document.getElementById('username').value = originalFields["username"];
    document.getElementById('email').value = originalFields["email"];
    document.getElementById('first_name').value = originalFields["firstName"];
    document.getElementById('last_name').value = originalFields["lastName"];
    document.getElementById('password').value = '';
    document.getElementById('confirm-password').value = '';
}
