const ADMIN_URL = 'http://localhost:5500';
const API_URL = 'http://localhost:5050';

function getHeaders() {
    return ({
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': ADMIN_URL
        }
    });
}

async function searchUsers(query) {
    const url = `${API_URL}/users?search=${query}`;

    const response = await fetch(url, getHeaders());

    if (!response.ok) {
        console.error(`Could not search for ${query}: server error`);
    }
    else {
        return await parseAuthResponse(response);
    }
}