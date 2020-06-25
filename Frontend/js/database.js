/*const resources = [
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
];*/

document.addEventListener('DOMContentLoaded', function() {
    const rows = document.querySelectorAll('[data-href]');

    for (let i = 0; i < rows.length; i++) {
        rows[i].addEventListener('click', function () {
            let href = rows[i].dataset.href;
            redirectTo(href);
        });
    }
    /*const href = usersRow.dataset.href;

    usersRow.addEventListener('click', function() {
        redirectTo(href);
    });*/
});

function redirectTo(href) {
    window.location.href = href;
}

// Not needed at the moment, because fetching data is now being handled by PHP
/*
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
}*/
