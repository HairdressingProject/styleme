import { redirect } from './redirect';

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

// currently selected colour
let colour = {
    id: '',
    colourName: '',
    colourHash: '',
    dateCreated: '',
    dateModified: ''
}

document.addEventListener('DOMContentLoaded', function() {
    redirect();
    
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
    colour = {};
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
    id.value = colour.id;

    // colour_name
    const colourName = document.getElementById('selected-colourName-edit');
    colourName.value = colour.colourName;

    // colour_hash
    const colourHash = document.getElementById('selected-colourHash-edit');
    colourHash.value = colour.colourHash;

}

function updateDeleteFields() {
    if (selectedRow) {
        updateFields();

        // id
        document.getElementById('selected-id-delete').textContent = colour.id;
        document.getElementById('delete_id').value = colour.id;

        // colour_name
        document.getElementById('selected-colourName-delete').textContent = colour.colourName;

        // colour_hash
        document.getElementById('selected-colourHash-delete').textContent = colour.colourHash;

        // date created
        document.getElementById('selected-date_created-delete').textContent = colour.dateCreated;

        // date modified
        document.getElementById('selected-date_modified-delete').textContent = colour.dateModified;
    }
}

function updateFields() {
    // id
    const id = colour.id || selectedRow.cells[0].textContent;

    // colour_name
    const colourName = colour.colourName || selectedRow.cells[1].textContent;

    // colour_hash
    const colourHash = colour.colourHash || selectedRow.cells[2].textContent;

    // date created
    const dateCreated = colour.dateCreated || selectedRow.cells[3].textContent;

    // date modified
    const dateModified = colour.dateModified || selectedRow.cells[4].textContent;

    colour = {
        id,
        colourName,
        colourHash,
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

    document.getElementById('selected-colourName-add').value = '';
    document.getElementById('selected-colourHash-add').value = '';
}

function closeDeleteForm(e) {
    e.preventDefault();

    const closeDeleteModalBtn = document.getElementById('close-delete-modal');
    closeDeleteModalBtn.click();
}