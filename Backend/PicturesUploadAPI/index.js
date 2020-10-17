const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const storage = multer.diskStorage({
    destination: path.join(__dirname, 'uploads/')
})
const upload = multer({dest: 'uploads/'});

const app = express();

app.post('/pictures', upload.single('picture'), (req, res, next) => {
    if (!req.file) {
        res.status(400).json({
            status: 400,
            reason: 'No file was uploaded'
        });
    } else {
        console.log(`Received file: ${req.file.originalname}`);
    const img = fs.crea
    }
    
});