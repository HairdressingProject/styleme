import { authenticate, getUser, logout } from './authenticate';

async function redirect() {
    const logoutLink = document.getElementById('logout');
    const userName = document.getElementById('user-name');
    const response = await authenticate();

    if (response !== null && response.id && response.userRole === 'admin') {
        const { user } = await getUser(response.id) || { firstName: 'User' };
        userName.textContent = `${user.firstName} ${user.lastName || ""}`;
    }
    else {
        // not authenticated
        // window.location.replace('/sign_in.php');
    }

    logoutLink.addEventListener('click', async function (e) {
        e.preventDefault();
        await logout();
    });
}

export { redirect }