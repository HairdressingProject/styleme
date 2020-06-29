function getHeaders() {
    return ({
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
            'Origin': 'http://localhost:5500/'
        }
    });
}

async function searchUsers(query) {
    const url = `https://localhost:5000/api/users?search=${query}`;

    const response = await fetch(url, getHeaders());

    if (!response.ok) {
        console.error(`Could not search for ${query}: server error`);
    }
    else {
        return await parseAuthResponse(response);
    }
}