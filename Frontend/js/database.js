const logoutLink = document.getElementById('logout');
const userName = document.getElementById('user-name');
const resources = [
    'colours',
    'face_shape_links',
    'face_shapes',
    'hair_length_links',
    'hair_lengths',
    'hair_style_links',
    'hair_styles',
    'skin_tone_links',
    'skin_tones',
    'user_features',
    'users'
];

document.addEventListener('DOMContentLoaded', async function () {
    const id = await authenticate();

    if (id) {
        const { user } = await getUser(id) || { firstName: 'User' };
        userName.textContent = `${user.firstName} ${user.lastName || ""}`;
    }
    else {
        // not authenticated
        window.location.replace('/sign_in.html');
    }

    logoutLink.addEventListener('click', async function (e) {
        e.preventDefault();
        await logout();
    });

    fetchAll();
});

async function fetchResource(resourceName) {
    const url = `https://localhost:5000/api/${resourceName}`;

    const response = await fetch(url, {
        method: 'GET',
        credentials: 'include',
        mode: 'cors',
        headers: {
            'Origin': 'http://localhost:5500'
        }
    });

    const r = await response.json();

    if (!response.ok) {
        console.log(`Error when trying to fetch ${resourceName}`);
        console.dir(r);
        return;
    }

    return r;
}

async function fetchAll() {
    let all = {};

    for (let i = 0; i < resources.length; i++) {
        const r = await fetchResource(resources[i]);
        all[resources[i]] = r[resources[i]];
    }

    console.dir(all);
}