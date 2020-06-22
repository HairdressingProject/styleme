document.addEventListener('DOMContentLoaded', async function () {
    const id = await authenticate();

    if (id) {
        const user = await getUser(id);
        console.dir(user);
    }
});