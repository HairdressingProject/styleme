<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: SkinTone.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-28
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/actions.php';

class SkinTone
{
    public int $id;
    public string $skinToneName;
    public string $dateCreated;
    public string $dateModified;

    /**
     * Requests the total number of skin tones available in the database
     * @param  string|null  $search Optional search query to count number of results
     * @return array
     */
    public function count(string $search = null)
    {
        if (isset($search)) {
            return countResource('skin_tones', $search);
        }
        return countResource('skin_tones');
    }

    /**
     * Browses skin tones, with optional pagination
     * @param  int|null  $limit Limit the number of results retrieved
     * @param  int|null  $offset Offset from which results should be retrieved
     * @return array
     */
    public function browse(int $limit = null, int $offset = null)
    {
        return browseResource('skin_tones', $limit, $offset);
    }

    public function read() {
        return readResource('skin_tones', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('skin_tones', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'SkinToneName' => Utils::sanitiseField($this->skinToneName, FILTER_SANITIZE_STRING),
        ));
    }

    public function add() {
        return addResource('skin_tones', array(
            'SkinToneName' => Utils::sanitiseField($this->skinToneName, FILTER_SANITIZE_STRING),
        ));
    }

    public function delete() {
        return deleteResource('skin_tones', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    /**
     * Search based on a given $query, with support for pagination
     * @param string $query Query string to search
     * @param  int|null  $limit Limit the number of results
     * @param  int|null  $offset Offset the results
     * @return array Response from the API
     */
    public function search(string $query, int $limit = null, int $offset = null) {
        return searchResource('skin_tones', $query, $limit, $offset);
    }

    /**
     * Sanitises all relevant fields/properties of this class, including the ID
     */
    public function sanitise() {
        if (isset($this->id) &&
            isset($this->skinToneName)
        ) {
            $this->id = Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
            $this->skinToneName = Utils::sanitiseField($this->skinToneName, FILTER_SANITIZE_STRING);
        }
    }

    /**
     * Handles form submission for the skin tones page
     * @param  string  $method One of: 'POST', 'PUT' or 'DELETE'
     * @return string|null Alert message
     */
    public function handleSubmit($method = 'POST')
    {
        switch ($method) {
            case 'POST':
                if (Utils::validateField('add_skinToneName', 'string')) {
                    // all good
                    $this->skinToneName = $_POST['add_skinToneName'];
                    $response = $this->add();

                    return Utils::handleResponse($response, [
                        '400'=> 'Invalid skin tone name field',
                        '500' => 'Could not add skin tone. Please try again later',
                        '200' => 'Skin tone successfully added'
                    ]);
                }
                else {
                    // add_skinToneName field was removed from form
                    return Utils::createAlert('Skin tone name cannot be empty', 'error');
                }
                break;

            case 'PUT':
                if (Utils::validateField('put_id', 'number')) {
                    if (Utils::validateField('put_hairLength_skinToneName', 'string')) {
                        $this->id = $_POST['put_id'];
                        $this->skinToneName = $_POST['put_hairLength_skinToneName'];
                        $response = $this->edit();

                        return Utils::handleResponse($response, [
                            '400' => 'Invalid skin tone name. It cannot exceed 128 characters.',
                            '404' => 'Skin tone not found.',
                            '500' => 'Could not updated skin tone. Please try again later.',
                            '200' => 'Skin tone successfully updated'
                        ]);
                    }
                    else {
                        return Utils::createAlert('Skin tone cannot be empty', 'error');
                    }
                }
                else {
                    return Utils::createAlert('Invalid skin tone ID', 'error');
                }
                break;

            case 'DELETE':
                if (Utils::validateField('delete_id', 'number')) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    return Utils::handleResponse($response, [
                        '404' => 'Skin tone was not found',
                        '400' => 'Invalid skin tone ID',
                        '500' => 'Could not update skin tone. Please try again later',
                        '200' => 'Skin tone successfully deleted'
                    ]);
                }
                else {
                    return Utils::createAlert('Invalid skin tone ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }
    }
}