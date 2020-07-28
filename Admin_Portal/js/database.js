import { redirect } from './redirect';

document.addEventListener('DOMContentLoaded', function() {
    redirect();
    const rows = document.querySelectorAll('[data-href]');

    for (let i = 0; i < rows.length; i++) {
        rows[i].addEventListener('click', function () {
            let href = rows[i].dataset.href;
            redirectTo(href);
        });
    }
});

function redirectTo(href) {
    window.location.href = href;
}