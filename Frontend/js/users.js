const tableRows = document.getElementsByClassName('_tables-row');
let selectedRow;

const btns = document.getElementsByClassName('_table-btn');

// edit modal
const openEditModalBtn = document.querySelector('[data-open="edit-modal"]');

// delete modal
const openDeleteModalBtn = document.querySelector('[data-open="delete-modal"]');

document.addEventListener('DOMContentLoaded', function() {

    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('_tables-cell')) {
            selectedRow = e.target.parentElement;
            selectRow(selectedRow)
        }
        else {
            if (selectedRow && !e.target.classList.contains('_table-btn')) {
                deselectRow(selectedRow);
                selectedRow = null;
            }
        }
    });

    openEditModalBtn.addEventListener('click', updateEditFields);
    openDeleteModalBtn.addEventListener('click', updateDeleteFields);
});

function selectRow(selected) {
    // deselect others
    for (let i = 0; i < tableRows.length; i++) {
        deselectRow(tableRows[i]);
    }

    selected.classList.add('_row-selected');

    // enable btns
    for (let i = 0; i < btns.length; i++) {
        if (!btns[i].classList.contains('_table-btn-add')) {
            btns[i].classList.remove('_table-btn-disabled');
            btns[i].disabled = false;
        }
    }
}

function deselectRow(selected) {
    selected.classList.remove('_row-selected');

    // disable btns
    for (let i = 0; i < btns.length; i++) {
        if (!btns[i].classList.contains('_table-btn-add')) {
            btns[i].classList.add('_table-btn-disabled');
            btns[i].disabled = true;
        }
    }
}

function updateEditFields() {
    if (selectedRow) {
        // username
        const username = document.getElementById('selected-username-edit');
        username.value = selectedRow.cells[1].textContent;

        // user_email
        const userEmail = document.getElementById('selected-user_email-edit');
        userEmail.value = selectedRow.cells[2].textContent;

        // first_name
        const firstName = document.getElementById('selected-first_name-edit');
        firstName.value = selectedRow.cells[3].textContent;

        // last_name
        const lastName = document.getElementById('selected-last_name-edit');
        lastName.value = selectedRow.cells[4].textContent;

        // user role
        const userRole = document.getElementById('selected-user_role-edit');
        userRole.value = selectedRow.cells[5].textContent;
    }
}

function updateDeleteFields() {
    if (selectedRow) {
        // id
        const id = document.getElementById('selected-id-delete');
        id.textContent = selectedRow.cells[0].textContent;

        // username
        const username = document.getElementById('selected-username-delete');
        username.textContent = selectedRow.cells[1].textContent;

        // user_email
        const userEmail = document.getElementById('selected-user_email-delete');
        userEmail.textContent = selectedRow.cells[2].textContent;

        // first_name
        const firstName = document.getElementById('selected-first_name-delete');
        firstName.textContent = selectedRow.cells[3].textContent;

        // last_name
        const lastName = document.getElementById('selected-last_name-delete');
        lastName.textContent = selectedRow.cells[4].textContent;

        // user role
        const userRole = document.getElementById('selected-user_role-delete');
        userRole.textContent = selectedRow.cells[5].textContent;

        // date created
        const dateCreated = document.getElementById('selected-date_created-delete');
        dateCreated.textContent = selectedRow.cells[6].textContent;

        // date modified
        const dateModified = document.getElementById('selected-date_modified-delete');
        dateModified.textContent = selectedRow.cells[7].textContent;
    }
}