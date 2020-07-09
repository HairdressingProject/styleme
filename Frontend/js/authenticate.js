const API_URL = 'http://api.stylebest.me:5000';
const APP_URL = 'http://stylebest.me';

async function authenticate() {
    const url = `${API_URL}/api/users/authenticate`;

    const response = await fetch(url, {
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': APP_URL
        }
    });

    if (!response.ok) {
        handleError(response);
    }
    else {
        // all good
        const r = await parseAuthResponse(response);
        return r.id;
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
    const url = `${API_URL}/api/users/${id}`;

    const response = await fetch(url, {
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': APP_URL
        }
    });

    if (!response.ok) {
        handleError(response);
    }
    else {
        const u = await parseAuthResponse(response);
        return u;
    }
}

function handleError(response) {
    if (response.status === 401) {
        console.log('User is not authenticated');
    }
    else if (response.status === 404) {
        console.log('User not found');
    }

    return ({});
}

async function logout() {
    const url = `${API_URL}/api/users/logout`;

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