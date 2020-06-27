<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: FaceShapeLink.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-28
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/browse.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/read.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/edit.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/add.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/delete.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/utils.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/FaceShape.php';

class FaceShapeLink
{
    public int $id;
    public int $faceShapeId;
    public string $linkName;
    public string $linkUrl;
    public string $dateCreated;
    public string $dateModified;

    public FaceShape $faceShape;

    public function browse() {
        return browseResource('face_shape_links');
    }

    public function read() {
        return readResource('face_shape_links', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('face_shape_links', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'FaceShapeId' => Utils::sanitiseField($this->faceShapeId, FILTER_SANITIZE_NUMBER_INT),
            'LinkName' => Utils::sanitiseField($this->linkName, FILTER_SANITIZE_STRING),
            'LinkUrl' => Utils::sanitiseField($this->linkUrl, FILTER_SANITIZE_URL)
        ));
    }

    public function add() {
        return addResource('face_shape_links', array(
            'FaceShapeId' => Utils::sanitiseField($this->faceShapeId, FILTER_SANITIZE_NUMBER_INT),
            'LinkName' => Utils::sanitiseField($this->linkName, FILTER_SANITIZE_STRING),
            'LinkUrl' => Utils::sanitiseField($this->linkUrl, FILTER_SANITIZE_URL)
        ));
    }

    public function delete() {
        return deleteResource('face_shape_links', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    /**
     * Handles form submission for the face shape links page
     * @param  string  $method One of: 'POST', 'PUT' or 'DELETE'
     * @return string|null Alert message
     */
    public function handleSubmit($method = 'POST')
    {
        switch ($method) {
            case 'POST':
                if (Utils::validateField('add_linkName', 'string') &&
                    Utils::validateField('add_linkUrl', 'string') &&
                    Utils::validateField('add_faceShapeId', 'number')
                ) {
                    $this->faceShapeId = $_POST['add_faceShapeId'];
                    $this->linkUrl = $_POST['add_linkUrl'];
                    $this->linkName = $_POST['add_linkName'];

                    $response = $this->add();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '500' => 'Could not add face shape link. Please try again later',
                        '200' => 'Face shape link successfully added'
                    ]);
                }
                break;

            case 'PUT':
                if (
                    Utils::validateField('put_linkName', 'string') &&
                    Utils::validateField('put_linkUrl', 'string') &&
                    Utils::validateField('put_faceShapeId', 'number') &&
                    Utils::validateField('put_id', 'number')
                ) {
                    $this->id = $_POST['put_id'];
                    $this->faceShapeId = $_POST['put_faceShapeId'];
                    $this->linkUrl = $_POST['put_linkUrl'];
                    $this->linkName = $_POST['put_linkName'];

                    $response = $this->edit();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '404' => 'Face shape link was not found',
                        '500' => 'Could not update face shape link. Please try again later',
                        '200' => 'Face shape link successfully updated'
                    ]);
                }
                break;

            case 'DELETE':
                if (Utils::validateField('delete_id', 'number')) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    return Utils::handleResponse($response, [
                        '404' => 'Face shape link was not found',
                        '400' => 'Invalid face shape link ID',
                        '500' => 'Could not delete face shape link. Please try again later',
                        '200' => 'Face shape link successfully deleted'
                    ]);
                }
                else {
                    return Utils::createAlert('Invalid face shape ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }

        return Utils::createAlert('Invalid fields', 'error');
    }
}