const logoutLink = document.getElementById('logout');

document.addEventListener('DOMContentLoaded', async function () {
    const id = await authenticate();

    if (id) {
        const user = await getUser(id);
        console.dir(user);
    }
    else {
        // not authenticated
        window.location.replace('/sign_in.html');
    }

    logoutLink.addEventListener('click', async function (e) {
        e.preventDefault();
        await logout();
    });
});