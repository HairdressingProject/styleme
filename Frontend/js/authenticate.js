const API_URL = 'https://api.styleme.best';
const APP_URL = 'https://styleme.best';

async function authenticate() {
    const url = `${API_URL}/users/authenticate`;

    const response = await fetch(url, {
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': APP_URL
        }
    });

    if (!response.ok) {
        return handleError(response);
    }
    else {
        // all good
        const r = await parseAuthResponse(response);
        return { id: r.id, userRole: r.userRole };
    }
}

async function parseAuthResponse(response) {
    try {
        const r = await response.json();
        return r;
    }
    catch (err) {
        console.log('could not get id from response');
        console.dir(err);

        return ({});
    }
}

async function getUser(id) {
    const url = `${API_URL}/users/${id}`;

    const response = await fetch(url, {
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': APP_URL
        }
    });

    if (!response.ok) {
        return handleError(response);
    }
    else {
        const u = await parseAuthResponse(response);
        return u;
    }
}

function handleError(response) {
    if (response.status === 401) {
        console.log('User is not authenticated');
        return null;
    }
    else if (response.status === 404) {
        console.log('User not found');
    }

    return ({});
}

async function logout() {
    const url = `${API_URL}/users/logout`;

    const response = await fetch(url, {
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': APP_URL
        }
    });

    if (response.ok) {
        window.location.replace('/sign_in.php');
    }
}

export {authenticate, logout, getUser}