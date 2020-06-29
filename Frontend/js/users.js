const tableRows = document.getElementsByClassName('_tables-row');
let selectedRow;
const clearBtn = document.getElementById('btn-clear');
const restoreBtn = document.getElementById('btn-restore');
const cancelBtn = document.getElementById('btn-cancel');
const editForm = document.getElementById('edit-form');

const btns = document.getElementsByClassName('_table-btn');

// edit modal
const openEditModalBtn = document.querySelector('[data-open="edit-modal"]');

// delete modal
const openDeleteModalBtn = document.querySelector('[data-open="delete-modal"]');

// currently selected user
let user = {
    id: '',
    username: '',
    userEmail: '',
    firstName: '',
    lastName: '',
    userRole: '',
    dateCreated: '',
    dateModified: ''
};

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

    openEditModalBtn.addEventListener('click', function() {
        if (selectedRow) {
            updateEditFields();
        }
    });
    openDeleteModalBtn.addEventListener('click', updateDeleteFields);
    restoreBtn.addEventListener('click', restoreEditFields);
    clearBtn.addEventListener('click', clearAddFields);
    cancelBtn.addEventListener('click', closeDeleteForm);
});

function selectRow(selected) {
    // deselect others
    for (let i = 0; i < tableRows.length; i++) {
        deselectRow(tableRows[i]);
    }

    selected.classList.add('_row-selected');
    user = {};
    updateFields();

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
        updateFields();

        // id
        const id = document.getElementById('selected-id-edit');
        id.value = user.id;

        // username
        const username = document.getElementById('selected-username-edit');
        username.value = user.username;

        // user_email
        const userEmail = document.getElementById('selected-user_email-edit');
        userEmail.value = user.userEmail;

        // first_name
        const firstName = document.getElementById('selected-first_name-edit');
        firstName.value = user.firstName;

        // last_name
        const lastName = document.getElementById('selected-last_name-edit');
        lastName.value = user.lastName;

        // user role
        const userRole = document.getElementById('selected-user_role-edit');
        userRole.value = user.userRole;
}

function updateDeleteFields() {
    if (selectedRow) {
        updateFields();

        // id
        document.getElementById('selected-id-delete').textContent = user.id;
        document.getElementById('delete_id').value = user.id;

        // username
        document.getElementById('selected-username-delete').textContent = user.username;

        // user_email
        document.getElementById('selected-user_email-delete').textContent = user.userEmail;

        // first_name
        document.getElementById('selected-first_name-delete').textContent = user.firstName;

        // last_name
        document.getElementById('selected-last_name-delete').textContent = user.lastName;

        // user role
        document.getElementById('selected-user_role-delete').textContent = user.userRole;

        // date created
        document.getElementById('selected-date_created-delete').textContent = user.dateCreated;

        // date modified
        document.getElementById('selected-date_modified-delete').textContent = user.dateModified;
    }
}

function updateFields() {
    // id
    const id = user.id || selectedRow.cells[0].textContent;

    // username
    const username = user.username || selectedRow.cells[1].textContent;

    // user_email
    const userEmail = user.userEmail || selectedRow.cells[2].textContent;

    // first_name
    const firstName = user.firstName || selectedRow.cells[3].textContent;

    // last_name
    const lastName = user.lastName || (selectedRow && selectedRow.cells[4].textContent) || '';

    // user role
    const userRole = user.userRole || selectedRow.cells[5].textContent;

    // date created
    const dateCreated = user.dateCreated || selectedRow.cells[6].textContent;

    // date modified
    const dateModified = user.dateModified || selectedRow.cells[7].textContent;

    user = {
        id,
        username,
        userEmail,
        firstName,
        lastName,
        userRole,
        dateCreated,
        dateModified
    };
}

function restoreEditFields(e) {
    e.preventDefault();

    updateEditFields();
    document.getElementById('selected-password-edit').value = '';
    document.getElementById('selected-confirm-password-edit').value = '';
}

function clearAddFields(e) {
    e.preventDefault();

    document.getElementById('selected-username-add').value = '';
    document.getElementById('selected-email-add').value = '';
    document.getElementById('selected-first_name-add').value = '';
    document.getElementById('selected-last_name-add').value = '';
    document.getElementById('selected-password-add').value = '';
    document.getElementById('selected-confirm-password-add').value = '';
}

function closeDeleteForm(e) {
    e.preventDefault();

    const closeDeleteModalBtn = document.getElementById('close-delete-modal');
    closeDeleteModalBtn.click();
}