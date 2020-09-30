<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: constants.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

define('ROOT', $_SERVER['DOCUMENT_ROOT']);

define("ENV", "development");

if (ENV === 'development') {
    define("API_URL", "http://localhost:5050");
}
else {
    define("API_URL", "https://api.styleme.best");
}
