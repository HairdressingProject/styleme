<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: utils.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/headers.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/authentication.php';

class Utils
{
    /**
     * Sends a HTTP request (details specified in the $headers) and returns the response
     * @param  string  $resourceUrl Full URL of the resource
     * @param  array  $headers
     * @return array Response from the API as an associative array
     */
    public static function getResponse(string $resourceUrl, array $headers) {
        $context = stream_context_create($headers);
        $response = [];

        if (isAuthenticated()) {
            $r = @file_get_contents($resourceUrl, false, $context);

            if ($r) {
                // I <3 PHP
                $response = (array) json_decode($r);
            }
            if (is_array($http_response_header)) {
                $parts = explode(' ', $http_response_header[0]);
                if (count($parts) > 1) {
                    $response['status'] = intval($parts[1]);
                }
            }
        }

        return $response;
    }

    // To be implemented
    public static function handleResponse($response) {
    }

    /**
     * Adds a new CSRF token to $_SESSION
     * @return string The CSRF created
     */
    public static function addCSRFToken() {
        session_start();
        if (empty($_SESSION['token'])) {
            try {
                $_SESSION['token'] = bin2hex(random_bytes(64));
            } catch (Exception $e) {
            }
        }
        return $_SESSION['token'];
    }

    /**
     * Verifies that the CSRF token sent by $_POST is valid
     * @return bool Result of the validation
     */
    public static function verifyCSRFToken() {
        if (!empty($_POST['token'])) {
            return hash_equals($_SESSION['token'], $_POST['token']);
        }
        return false;
    }

    /**
     * Display alert messages
     * @param string $message Message to be displayed
     * @param string $type One of: 'error' or 'success'. Additional types may be added in the future.
     * @return string Alert message ready to be echo'ed to the DOM
     */
    public static function createAlert(string $message, string $type) {
        if (isset($type)) {
            $alert = '';
            if ($type === 'error') {
                $alert =
                    '<div id="alert" class="alert alert-error">'.
                    '<p class="alert-message">'.
                    $message .
                    '</p>'.
                    '<button class="alert-close" id="alert-close-btn">'.
                    '<img src="/img/icons/close.svg" alt="Close" />'.
                    '</button>'.
                    '</div>';
            }
            else if ($type === 'success') {
                $alert =
                    '<div id="alert" class="alert alert-success">'.
                    '<p class="alert-message">'.
                    $message .
                    '</p>'.
                    '<button class="alert-close" id="alert-close-btn">'.
                    '<img src="/img/icons/close.svg" alt="Close" />'.
                    '</button>'.
                    '</div>';
            }
            else {
                // you may display additional alert types here, such as warning or info
            }

            return $alert;
        }
        return '';
    }
}