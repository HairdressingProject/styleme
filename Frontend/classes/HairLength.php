<?php
/*******************************************************
 * Project:     Admin-Portal-v2
 * File:        HairLength.php
 * Author:      Gerardo G.
 * Date:        2020-06-27
 * Version:     1.0.0
 * Description:
 *******************************************************/

require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/browse.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/read.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/edit.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/add.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/delete.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/utils.php';

class HairLength
{
    public int $id;
    public string $hairLengthName;
    public string $dateCreated;
    public string $dateModified;

    public function browse() {
        $this->sanitise();
        return browseResource('hair_lengths');
    }

    public function read() {
        return readResource('hair_lengths', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('hair_lengths', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'HairLengthName' => Utils::sanitiseField($this->hairLengthName, FILTER_SANITIZE_STRING),
        ));
    }

    public function add() {
        return addResource('hair_lengths', array(
            'HairLengthName' => Utils::sanitiseField($this->hairLengthName, FILTER_SANITIZE_STRING),
        ));
    }

    public function delete() {
        return deleteResource('hair_lengths', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    /**
     * Sanitises all relevant fields/properties of this class, including the ID
     */
    public function sanitise() {
        if (isset($this->id) &&
            isset($this->hairLengthName)
        ) {
            $this->id = Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
            $this->hairLengthName = Utils::sanitiseField($this->hairLengthName, FILTER_SANITIZE_STRING);
        }
    }

    /**
     * Handles form submission for the users page
     * @param  string  $method One of: 'POST', 'PUT' or 'DELETE'
     * @return string|null Alert message
     */
    public function handleSubmit($method = 'POST')
    {
        switch ($method) {
            case 'POST':
                if ($this->validateHairLengthName('add_hairLengthName')) {
                    // all good
                    $this->hairLengthName = $_POST['add_hairLengthName'];
                    $response = $this->add();

                    if (isset($response['status'])) {
                        switch($response['status']) {
                            case 400:
                                return Utils::createAlert('Invalid hair length name field', 'error');
                            case 500:
                                return Utils::createAlert('Could not add hair length. Please try again later', 'error');
                            case 200:
                            case 201:
                                return Utils::createAlert('Hair length successfully added', 'success');
                            default:
                                // unknown status
                                break;
                        }
                    }
                }
                else {
                    // add_hairLengthName field was removed from form
                    return Utils::createAlert('Hair length name cannot be empty', 'error');
                }
                break;

            case 'PUT':
                if (isset($_POST['put_id']) && is_numeric($_POST['put_id'])) {
                    if ($this->validateHairLengthName('put_hairLength_hairLengthName')) {
                        $this->id = $_POST['put_id'];
                        var_dump($this->hairLengthName);
                        $this->hairLengthName = $_POST['put_hairLength_hairLengthName'];
                        $response = $this->edit();

                        if (isset($response['status'])) {
                            switch ($response['status']) {
                                case 400:
                                    return Utils::createAlert('Invalid hair length name. It cannot exceed 128 characters.', 'error');
                                case 404:
                                    return Utils::createAlert('Hair length not found.', 'error');
                                case 500:
                                    return Utils::createAlert('Could not updated hair length. Please try again later.', 'error');
                                case 200:
                                    return Utils::createAlert('Hair length successfully updated', 'success');
                                default:
                                    break;
                            }
                        }
                    }
                    else {
                        return Utils::createAlert('Hair length cannot be empty', 'error');
                    }
                }
                else {
                    return Utils::createAlert('Invalid hair length ID', 'error');
                }
                break;

            case 'DELETE':
                if (isset($_POST['delete_id']) && is_numeric($_POST['delete_id'])) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    if (isset($response['status'])) {
                        switch ($response['status']) {
                            case 404:
                                return Utils::createAlert('Hair length was not found', 'error');
                            case 400:
                                return Utils::createAlert('Invalid hair length ID', 'error');
                            case 500:
                                return Utils::createAlert('Could not update hair length. Please try again later', 'error');
                            case 200:
                                return Utils::createAlert('Hair length successfully deleted', 'success');
                            default:
                                break;
                        }
                    }
                }
                else {
                    return Utils::createAlert('Invalid hair length ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }
        return null;
    }

    public function validateHairLengthName($hairLengthName) {
        return isset($_POST[$hairLengthName]) && is_string($_POST[$hairLengthName]) && !empty(trim($_POST[$hairLengthName]));
    }
}