<?php
/*******************************************************
 * Package:     HairdressingProject
 * Project:     Admin-Portal-v2
 * File:        FaceShape.php
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

class FaceShape
{
    public int $id;
    public string $shapeName;
    public string $dateCreated;
    public string $dateModified;

    public function browse() {
        $this->sanitise();
        return browseResource('face_shapes');
    }

    public function read() {
        return readResource('face_shapes', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('face_shapes', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'ShapeName' => Utils::sanitiseField($this->shapeName, FILTER_SANITIZE_STRING),
        ));
    }

    public function add() {
        return addResource('face_shapes', array(
            'ShapeName' => Utils::sanitiseField($this->shapeName, FILTER_SANITIZE_STRING),
        ));
    }

    public function delete() {
        return deleteResource('face_shapes', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    /**
     * Sanitises all relevant fields/properties of this class, including the ID
     */
    public function sanitise() {
        if (isset($this->id) &&
            isset($this->shapeName)
        ) {
            $this->id = Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
            $this->shapeName = Utils::sanitiseField($this->shapeName, FILTER_SANITIZE_STRING);
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
                if ($this->validateShapeName('add_shapeName')) {
                    // all good
                    $this->shapeName = $_POST['add_shapeName'];
                    $response = $this->add();

                    if (isset($response['status'])) {
                        switch($response['status']) {
                            case 400:
                                return Utils::createAlert('Invalid shape name field', 'error');
                            case 500:
                                return Utils::createAlert('Could not add face shape. Please try again later', 'error');
                            case 200:
                            case 201:
                                return Utils::createAlert('Face shape successfully added', 'success');
                            default:
                                // unknown status
                                break;
                        }
                    }
                }
                else {
                    // add_shapeName field was removed from form
                    return Utils::createAlert('Shape name cannot be empty', 'error');
                }
                break;

            case 'PUT':
                    if (isset($_POST['put_id']) && is_numeric($_POST['put_id'])) {
                        if ($this->validateShapeName('put_faceShape_shapeName')) {
                            $this->id = $_POST['put_id'];
                            $this->shapeName = $_POST['put_faceShape_shapeName'];
                            $response = $this->edit();

                            if (isset($response['status'])) {
                                switch ($response['status']) {
                                    case 400:
                                        return Utils::createAlert('Invalid shape name. It cannot exceed 128 characters.', 'error');
                                    case 404:
                                        return Utils::createAlert('Face shape not found.', 'error');
                                    case 500:
                                        return Utils::createAlert('Could not updated face shape. Please try again later.', 'error');
                                    case 200:
                                        return Utils::createAlert('Face shape successfully updated', 'success');
                                    default:
                                        break;
                                }
                            }
                        }
                        else {
                            return Utils::createAlert('Shape name cannot be empty', 'error');
                        }
                    }
                    else {
                        return Utils::createAlert('Invalid face shape ID', 'error');
                    }
                break;

            case 'DELETE':
                    if (isset($_POST['delete_id']) && is_numeric($_POST['delete_id'])) {
                        $this->id = $_POST['delete_id'];

                        $response = $this->delete();

                        if (isset($response['status'])) {
                            switch ($response['status']) {
                                case 404:
                                    return Utils::createAlert('Face shape was not found', 'error');
                                case 400:
                                    return Utils::createAlert('Invalid face shape ID', 'error');
                                case 500:
                                    return Utils::createAlert('Could not update face shape. Please try again later', 'error');
                                case 200:
                                    return Utils::createAlert('Face shape successfully deleted', 'success');
                                default:
                                    break;
                            }
                        }
                    }
                    else {
                        return Utils::createAlert('Invalid face shape ID field', 'error');
                    }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }
        return null;
    }

    public function validateShapeName($shapeName) {
        return isset($_POST[$shapeName]) && is_string($_POST[$shapeName]) && !empty(trim($_POST[$shapeName]));
    }
}