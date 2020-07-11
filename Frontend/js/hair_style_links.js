import { redirect } from './redirect';
redirect();

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

// currently selected hairStyle
let hairStyleLink = {
    id: '',
    hairStyleId: '',
    hairStyleName: '',
    linkName: '',
    linkUrl: '',
    dateCreated: '',
    dateModified: ''
}

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
    hairStyleLink = {};
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
    id.value = hairStyleLink.id;

    // face shape name
    const hairStyleName = document.getElementById('selected-hairStyle-edit');
    hairStyleName.value = hairStyleLink.hairStyleId;

    // link name
    const linkName = document.getElementById('selected-linkName-edit');
    linkName.value = hairStyleLink.linkName;

    // link URL
    const linkUrl = document.getElementById('selected-linkUrl-edit');
    linkUrl.value = hairStyleLink.linkUrl;
}

function updateDeleteFields() {
    if (selectedRow) {
        updateFields();

        // id
        document.getElementById('selected-id-delete').textContent = hairStyleLink.id;
        document.getElementById('delete_id').value = hairStyleLink.id;

        // face shape name
        document.getElementById('selected-hairStyle-delete').textContent = hairStyleLink.hairStyleName;

        // link name
        document.getElementById('selected-linkName-delete').textContent = hairStyleLink.linkName;

        // link url
        document.getElementById('selected-linkUrl-delete').textContent = hairStyleLink.linkUrl;

        // date created
        document.getElementById('selected-date_created-delete').textContent = hairStyleLink.dateCreated;

        // date modified
        document.getElementById('selected-date_modified-delete').textContent = hairStyleLink.dateModified;
    }
}

function updateFields() {
    // id
    const id = hairStyleLink.id || selectedRow.cells[0].textContent;

    // face shape id
    const hairStyleId = hairStyleLink.hairStyleId || selectedRow.cells[1].dataset['hairStyleId'];

    // get name from rows
    const allRows = document.querySelectorAll('[data-hair-style-id]');
    const hairStyle = [...allRows].filter(r => r.dataset['hairStyleId'] === hairStyleId)[0];

    const hairStyleName = hairStyleLink.hairStyleName || hairStyle.textContent;

    // link name
    const linkName = hairStyleLink.linkName || selectedRow.cells[2].textContent;

    // link url
    const linkUrl = hairStyleLink.linkUrl || selectedRow.cells[3].textContent;

    // date created
    const dateCreated = hairStyleLink.dateCreated || selectedRow.cells[4].textContent;

    // date modified
    const dateModified = hairStyleLink.dateModified || selectedRow.cells[5].textContent;

    hairStyleLink = {
        id,
        hairStyleId,
        hairStyleName,
        linkName,
        linkUrl,
        dateCreated,
        dateModified
    };
}

function restoreEditFields(e) {
    e.preventDefault();

    updateEditFields();
}

function clearAddFields(e) {
    e.preventDefault();

    document.getElementById('selected-linkName-add').value = '';
    document.getElementById('selected-linkUrl-add').value = '';
}

function closeDeleteForm(e) {
    e.preventDefault();

    const closeDeleteModalBtn = document.getElementById('close-delete-modal');
    closeDeleteModalBtn.click();
}