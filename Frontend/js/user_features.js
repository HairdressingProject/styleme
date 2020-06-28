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

// currently selected userFeature
let userFeature = {
    id: '',
    userId: '',
    userName: '',
    faceShapeId: '',
    faceShapeName: '',
    skinToneId: '',
    skinToneName: '',
    hairStyleId: '',
    hairStyleName: '',
    hairLengthId: '',
    hairLengthName: '',
    hairColourId: '',
    hairColourName: '',
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
    userFeature = {};
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
    id.value = userFeature.id;

    // userName
    const userName = document.getElementById('selected-userName-edit');
    userName.value = userFeature.userName;

    // face shape name
    const faceShapeName = document.getElementById('selected-')

}

function updateDeleteFields() {
    if (selectedRow) {
        updateFields();

        // id
        document.getElementById('selected-id-delete').textContent = userFeature.id;
        document.getElementById('delete_id').value = userFeature.id;

        // userName
        document.getElementById('selected-shapeName-delete').textContent = faceShape.shapeName;

        // face shape name
        document.getElementById('')
        // skin tone name
        // hair style name
        // hair length name
        // hair colour name

        // date created
        document.getElementById('selected-date_created-delete').textContent = faceShape.dateCreated;

        // date modified
        document.getElementById('selected-date_modified-delete').textContent = faceShape.dateModified;
    }
}

function updateFields() {
    // id
    const id = userFeature.id || selectedRow.cells[0].textContent;

    // user id
    const userId = userFeature.userId || selectedRow.cells[1].dataset['userId'];
    // user name
    const allUserNameRows = document.querySelectorAll('[data-user-id]');
    const user = [...allUserNameRows].filter(r => r.dataset['userId'] === userId)[0];
    const userName = userFeature.userName || user.textContent;


    // face shape id
    const faceShapeId = userFeature.faceShapeId || selectedRow.cells[2].dataset['faceShapeId'];
    // face shape name (get name from rows)
    const allFaceShapeRows = document.querySelectorAll('[data-face-shape-id]');
    const faceShape = [...allFaceShapeRows].filter(r => r.dataset['faceShapeId'] === faceShapeId)[0];
    const faceShapeName = userFeature.faceShapeName || faceShape.textContent;

    // skin tone id
    const skinToneId = userFeature.skinToneId || selectedRow.cells[3].dataset['skinToneId'];
    // skin tone name (get name from rows)
    const allSkinToneRows = document.querySelectorAll('[data-skin-tone-id]');
    const skinTone = [...allSkinToneRows].filter(r => r.dataset['skinToneId'] === skinToneId)[0];
    const skinToneName = userFeature.skinToneName || skinTone.textContent;

    // hair style id
    const hairStyleId = userFeature.hairStyleId || selectedRow.cells[4].dataset['hairStyleId'];
    // hair style name
    const allHairStyleRows = document.querySelectorAll('[data-hair-style-id]');
    const hairStyle = [...allHairStyleRows].filter(r => r.dataset['hairStyleId'] === hairStyleId)[0];
    const hairStyleName = userFeature.hairStyleName || hairStyle.textContent;

    // hair length id
    const hairLengthId = userFeature.hairLengthId || selectedRow.cells[5].dataset['hairLengthId'];
    // hair length name
    const allHairLengthRows = document.querySelectorAll('[data-hair-length-id]');
    const hairLength = [...allHairLengthRows].filter(r => r.dataset['hairLengthId'] === hairLengthId)[0];
    const hairLengthName = userFeature.hairStyleName || hairLength.textContent;

    //hair colour id
    const hairColourId = userFeature.hairColourId || selectedRow.cells[6].dataset['hairColourId'];
    // hair colour name
    const allHairColourRows = document.querySelectorAll('[data-hair-colour-id]');
    const hairColour = [...allHairColourRows].filter(r => r.dataset['hairColourId'] === hairColourId)[0];
    const hairColourName = userFeature.hairColourName || hairColour.textContent;


    // date created
    const dateCreated = userFeature.dateCreated || selectedRow.cells[2].textContent;

    // date modified
    const dateModified = userFeature.dateModified || selectedRow.cells[3].textContent;

    userFeature = {
        id,
        faceShapeId,
        faceShapeName,
        skinToneId,
        skinToneName,
        hairStyleId,
        hairStyleName,
        hairLengthId,
        hairLengthName,
        hairColourId,
        hairColourName,
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

    document.getElementById('selected-shapeName-add').value = '';

}

function closeDeleteForm(e) {
    e.preventDefault();

    const closeDeleteModalBtn = document.getElementById('close-delete-modal');
    closeDeleteModalBtn.click();
}