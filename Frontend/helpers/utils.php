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

    /**
     * Handles a variety of HTTP responses based on their status code
     * @param  array  $response Associative array containing status code of the response
     * @param  array  $messages Associative array of messages to be echo'ed to the DOM as alerts.
     *
     * Example:
     *      $messages = [
     *          '400' => 'Invalid fields',
     *          '404' => 'Not found',
     *          ...
     *      ]
     * @return string|null Alert message - if both $response and $messages are valid - or null otherwise
     */
    public static function handleResponse(array $response, array $messages) {
        if (isset($response) && isset($response['status'])) {
            $alertMessages = [];
            if (isset($response['errors'])) {
                $alertMessages = self::flattenErrorMessages($response['errors']);
            }
            switch ($response['status']) {
                case 400:
                    // bad request, invalid fields
                    $alerts = '';
                    for ($i = 0; $i < count($alertMessages); $i++) {
                        $alerts = $alerts . self::createAlert($alertMessages[$i], 'error');
                    }

                    if (!empty($alerts)) {
                        return $alerts;
                    }

                    // fallback message
                    return Utils::createAlert($messages['400'], 'error');

                case 404:
                    return Utils::createAlert($messages['404'], 'error');
                case 409:
                    // conflict, user already exists
                    return Utils::createAlert($messages['409'], 'error');

                case 500:
                    // something went wrong with the API server
                    return Utils::createAlert($messages['500'], 'error');

                case 200:
                case 201:
                    // all good!
                    return Utils::createAlert(isset($messages['200']) ? $messages['200'] : $messages['201'], 'success');
                default:
                    // unknown status
                    break;

            }
        }
        return null;
    }

    /**
     * Flattens error messages contained in responses
     * @param array $errors
     * @return array Single-dimensional array containing all error messages
     */
    public static function flattenErrorMessages(array $errors) {
        $msgs = [];

        foreach ($errors as &$values) {
            for ($i = 0; $i < count($values); $i++) {
                $msgs[] = &$values[$i];
            }
        }

        return $msgs;
    }

    private static function getErrorMessagesFromResponse($response) {
        $errorMessages = [];

        if (isset($response['errors'])) {
            for ($i = 0; $i < count($response['errors']); $i++) {
                $errorMessages[] = $response['errors'][$i];
            }
        }
    }

    /**
     * Sanitises an individual property/field of this class
     * @param $field
     * @param  int  $type ID from the filter constants of filter_var (see docs for more info)
     * @return string
     */
    public static function sanitiseField($field, $type) {
        if (isset($field)) {
            return filter_var($field, $type);
        }
        return '';
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

    /**
     * Validates an individual field based on its value and type.
     * Returns false if parameters are invalid.
     * @param string $field 'name' attribute in the HTML form associated with this field
     * @param string $type One of: 'string' or 'number'
     * @return bool Validation result
     */
    public static function validateField(string $field, string $type) {
        if (isset($field) && isset($type)) {
            switch ($type) {
                case 'string':
                    return isset($_POST[$field]) && is_string($_POST[$field]) && !empty(trim($_POST[$field]));

                case 'number':
                    return isset($_POST[$field]) && is_numeric($_POST[$field]) && intval($_POST[$field]) > 0;

                default:
                    return false;
            }
        }

        return false;
    }

    /**
     * Formats date/time as follows: June 27th, 2020 03:05:11 PM
     * @param $dateTime
     * @return false|string Formatted date/time as a string, 'Never' if $dateTime is null or false, if it wasn't able to format
     */
    public static function prettyPrintDateTime($dateTime) {
        if (isset($dateTime)) {
            return date('F jS, Y h:i:s A', strtotime($dateTime));
        }
        return 'Never';
    }

    /**
     * Determines the current protocol, i.e. HTTP or HTTPS
     * @return string Either 'http://' or 'https://'
     */
    public static function getUrlProtocol() {
        $protocol = 'http://';
        // haxx to check whether the application is running under HTTPS or HTTP
        if (isset($_SERVER['HTTPS']) &&
            ($_SERVER['HTTPS'] == 'on' || $_SERVER['HTTPS'] == 1) ||
            isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
            $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
            $protocol = 'https://';
        }

        return $protocol;
    }

    /**
     * Paginates a resource based on given parameters, such as the number of items to display
     * @param  User|Colour|FaceShape|FaceShapeLink|HairLength|HairLengthLink|HairLength|HairLengthLink|SkinTone|SkinToneLink|UserFeature  $resource The resource object to be paginated
     * @param  string  $resourceName Name of the resource to be requested in API endpoints
     * @param  int  $itemsPerPage Maximum number of items to display per page
     * @param  string  $currentBaseUrl Current URL of the page without query strings such as ?page=1
     * @return array Associative array with pagination results, in the following format:
     *
     * Example:
     *      $results = [
     *          'resources' => [],
     *          'count' => 0,
     *          'page' => 1,
     *          'totalNumberOfPages' => 1
     *      ]
     */
    public static function paginateResource(
        object $resource,
        string $resourceName,
        int $itemsPerPage,
        string $currentBaseUrl
    ) {
        // get total number of users
        $countResponse = $resource->count();
        $count = $countResponse['count'];

        $totalNumberOfPages = $count < $itemsPerPage ? 1 : (($count - 1) / $itemsPerPage) + 1;

        // get current page
        if (isset($_GET['page']) && is_numeric($_GET['page'])) {
            $page = intval(Utils::sanitiseField($_GET['page'], FILTER_SANITIZE_NUMBER_INT));
        }

        else {
            // invalid page query, redirect to the first one
            // redirect to first page
            echo '<script>window.location.href="' . $currentBaseUrl . '?page=1";</script>';
            exit();
        }

        if ($page > $totalNumberOfPages) {
            // redirect to last page
            echo '<script>window.location.href="' . $currentBaseUrl . '?page=' . $totalNumberOfPages . '";</script>';
            exit();
        }

        if ($page <= 0) {
            // redirect to first page
            echo '<script>window.location.href="' . $currentBaseUrl . '?page=1";</script>';
            exit();
        }

        $offset = ($page - 1) * $itemsPerPage;
        $browseResponse = $resource->browse($itemsPerPage, $offset);

        return array(
            'resources' => $browseResponse[$resourceName],
            'count' => $count,
            'page' => $page,
            'totalNumberOfPages' => $totalNumberOfPages
        );
    }
}