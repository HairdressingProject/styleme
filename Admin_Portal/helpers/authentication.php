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
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/UserRoles.php';

/**
 * Verifies if the user is authenticated
 * @return array|bool Authenticated user or false (if not authenticated)
 */
ini_set("display_errors", 1); error_reporting(E_ALL);

function isAuthenticated() {
    $opts = generateHeaders('GET');
    $authUrl = API_URL . '/users/authenticate';

    $ctx = stream_context_create($opts);

    $response = @file_get_contents($authUrl, false, $ctx);

    $r = (array) json_decode($response);

    return isset($r['id']) ? array('id' => $r['id'], 'userRole' => $r['userRole']) : false;
}

function handleAuthorisation() {
    $user = isAuthenticated();

    if (!($user && $user['userRole'] === UserRoles::ADMIN)) {
        $signIn = Utils::getUrlProtocol() . $_SERVER['SERVER_NAME'] . '/sign_in.php';
        header('Location: ' . $signIn, true);
    }
}