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
let hairStyle = {
    id: '',
    hairStyleName: '',
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
    hairStyle = {};
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
    id.value = hairStyle.id;

    // hair_style
    const hairStyleName = document.getElementById('selected-hairStyleName-edit');
    hairStyleName.value = hairStyle.hairStyleName;

}

function updateDeleteFields() {
    if (selectedRow) {
        updateFields();

        // id
        document.getElementById('selected-id-delete').textContent = hairStyle.id;
        document.getElementById('delete_id').value = hairStyle.id;

        // hair_style
        document.getElementById('selected-hairStyleName-delete').textContent = hairStyle.hairStyleName;

        // date created
        document.getElementById('selected-date_created-delete').textContent = hairStyle.dateCreated;

        // date modified
        document.getElementById('selected-date_modified-delete').textContent = hairStyle.dateModified;
    }
}

function updateFields() {
    // id
    const id = hairStyle.id || selectedRow.cells[0].textContent;

    // hair_style
    const hairStyleName = hairStyle.hairStyleName || selectedRow.cells[1].textContent;

    // date created
    const dateCreated = hairStyle.dateCreated || selectedRow.cells[2].textContent;

    // date modified
    const dateModified = hairStyle.dateModified || selectedRow.cells[3].textContent;

    hairStyle = {
        id,
        hairStyleName,
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

    document.getElementById('selected-hairStyleName-add').value = '';

}

function closeDeleteForm(e) {
    e.preventDefault();

    const closeDeleteModalBtn = document.getElementById('close-delete-modal');
    closeDeleteModalBtn.click();
}