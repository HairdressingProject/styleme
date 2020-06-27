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
                if (Utils::validateField('add_hairLengthName', 'string')) {
                    // all good
                    $this->hairLengthName = $_POST['add_hairLengthName'];
                    $response = $this->add();

                    return Utils::handleResponse($response, [
                        '400'=> 'Invalid hair length name field',
                        '500' => 'Could not add hair length. Please try again later',
                        '200' => 'Hair length successfully added'
                    ]);
                }
                else {
                    // add_hairLengthName field was removed from form
                    return Utils::createAlert('Hair length name cannot be empty', 'error');
                }
                break;

            case 'PUT':
                if (Utils::validateField('put_id', 'number')) {
                    if (Utils::validateField('put_hairLength_hairLengthName', 'string')) {
                        $this->id = $_POST['put_id'];
                        $this->hairLengthName = $_POST['put_hairLength_hairLengthName'];
                        $response = $this->edit();

                        return Utils::handleResponse($response, [
                            '400' => 'Invalid hair length name. It cannot exceed 128 characters.',
                            '404' => 'Hair length not found.',
                            '500' => 'Could not updated hair length. Please try again later.',
                            '200' => 'Hair length successfully updated'
                        ]);
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
                if (Utils::validateField('delete_id', 'number')) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    return Utils::handleResponse($response, [
                        '404' => 'Hair length was not found',
                        '400' => 'Invalid hair length ID',
                        '500' => 'Could not update hair length. Please try again later',
                        '200' => 'Hair length successfully deleted'
                    ]);
                }
                else {
                    return Utils::createAlert('Invalid hair length ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }
    }
}