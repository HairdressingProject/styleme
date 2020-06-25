const sidebar = document.getElementById('sidebar');
const sidebarOpen = document.getElementById('sidebar-open');
const sidebarClose = document.getElementById('sidebar-close');
const icons = document.getElementsByClassName('_sidebar-item-icon');
const linkTexts = document.getElementsByClassName('_sidebar-item-text');
const mainContent = document.getElementsByClassName('main')[0] || document.getElementsByClassName('account-main')[0];

document.addEventListener('DOMContentLoaded', function () {
    sidebar.style.height = document.body.offsetHeight + 'px';

    sidebarClose.addEventListener('click', closeSidebar);
    sidebarOpen.addEventListener('click', openSidebar);
});

function closeSidebar() {
    sidebar.classList.add('_sidebar-closed');
    sidebarClose.classList.add('hide');
    sidebarOpen.classList.remove('hide');
    sidebarOpen.style.transform = 'translateX(250%)';

    addSlideIconsLeft();
    hideLinksText();

    mainContent.classList.add('main-sidebar-closed');
}

function openSidebar() {
    sidebar.classList.remove('_sidebar-closed');
    sidebarClose.classList.remove('hide');
    sidebarOpen.classList.add('hide');
    sidebarOpen.classList.remove('slide-left');
    sidebarOpen.style.transform = 'translateX(-50%)';

    removeSlideIconsLeft();
    unhideLinksText();

    mainContent.classList.remove('main-sidebar-closed');
}

function addSlideIconsLeft() {
    for (let i = 0; i < icons.length; i++) {
        icons[i].classList.add('slide-left');
    }
}

function removeSlideIconsLeft() {
    for (let i = 0; i < icons.length; i++) {
        icons[i].classList.remove('slide-left');
    }
}

function hideLinksText() {
    for (let i = 0; i < linkTexts.length; i++) {
        linkTexts[i].classList.add('hide');
    }
}

function unhideLinksText() {
    for (let i = 0; i < linkTexts.length; i++) {
        linkTexts[i].classList.remove('hide');
    }
}