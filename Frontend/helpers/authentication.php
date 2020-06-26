<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: authentication.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/constants.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/headers.php';

/**
 * Verifies if the user is authenticated
 * @return bool Whether the user is authenticated
 */
function isAuthenticated() {
    $opts = generateHeaders('GET');

    $context = stream_context_create($opts);
    $authUrl = API_URL . '/api/users/authenticate';

    $userData = @file_get_contents($authUrl, false, $context);

    return isset($userData);
}