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
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Verifies if the user is authenticated
 * @return int|bool ID of authenticated user or false (if not authenticated)
 */
ini_set("display_errors", 1); error_reporting(E_ALL);

function isAuthenticated() {
    $opts = generateHeaders('GET');
    $authUrl = API_URL . '/api/users/authenticate';

    $ctx = stream_context_create($opts);

    $response = file_get_contents($authUrl, false, $ctx);

    $r = (array) json_decode($response);

    return isset($r['id']) ? $r['id'] : false;
}