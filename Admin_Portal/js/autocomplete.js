const searchFields = document.getElementsByClassName('_search-field');
const searchBtns = document.getElementsByClassName('_search-btn');

let mappedFields = {};

[...searchFields].forEach(searchField => {
    searchField.addEventListener('input', function (e) {
        mappedFields[e.target.nextElementSibling.dataset.search] = e.target.value;
    });
});

[...searchBtns].forEach(searchBtn => {
    searchBtn.addEventListener('click', async function (e) {
        const resourceName = e.target.parentElement.dataset.search
        const input = mappedFields[resourceName];

        if (input && input.trim()) {
            let results;
            switch(resourceName.trim().toLowerCase()) {
                case 'users':
                    results = await searchUsers(input);
                    if (results) {
                        results = results['users'].map(u => u['userName']);
                    }
                    break;

                default:
                    break;
            }

            if (results) {
                const container = e.target.parentElement.parentElement;
                let resultsList = document.createElement('ul');

                results.forEach(user => {
                    const item = document.createElement('li');
                    item.textContent = user;
                    resultsList.appendChild(item);
                })

                container.appendChild(resultsList);
            }
        }
    })
});

