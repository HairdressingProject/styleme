<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: HairStyleLink.php
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
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/HairStyle.php';

class HairStyleLink
{
    public int $id;
    public int $hairStyleId;
    public string $linkName;
    public string $linkUrl;
    public string $dateCreated;
    public string $dateModified;

    public HairStyle $hairStyle;

    public function browse() {
        return browseResource('hair_style_links');
    }

    public function read() {
        return readResource('hair_style_links', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('hair_style_links', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'HairStyleId' => Utils::sanitiseField($this->hairStyleId, FILTER_SANITIZE_NUMBER_INT),
            'LinkName' => Utils::sanitiseField($this->linkName, FILTER_SANITIZE_STRING),
            'LinkUrl' => Utils::sanitiseField($this->linkUrl, FILTER_SANITIZE_URL)
        ));
    }

    public function add() {
        return addResource('hair_style_links', array(
            'HairStyleId' => Utils::sanitiseField($this->hairStyleId, FILTER_SANITIZE_NUMBER_INT),
            'LinkName' => Utils::sanitiseField($this->linkName, FILTER_SANITIZE_STRING),
            'LinkUrl' => Utils::sanitiseField($this->linkUrl, FILTER_SANITIZE_URL)
        ));
    }

    public function delete() {
        return deleteResource('hair_style_links', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    /**
     * Handles form submission for the hair shape links page
     * @param  string  $method One of: 'POST', 'PUT' or 'DELETE'
     * @return string|null Alert message
     */
    public function handleSubmit($method = 'POST')
    {
        switch ($method) {
            case 'POST':
                if (Utils::validateField('add_linkName', 'string') &&
                    Utils::validateField('add_linkUrl', 'string') &&
                    Utils::validateField('add_hairStyleId', 'number')
                ) {
                    $this->hairStyleId = $_POST['add_hairStyleId'];
                    $this->linkUrl = $_POST['add_linkUrl'];
                    $this->linkName = $_POST['add_linkName'];

                    $response = $this->add();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '500' => 'Could not add hair style link. Please try again later',
                        '200' => 'Hair style link successfully added'
                    ]);
                }
                break;

            case 'PUT':
                if (
                    Utils::validateField('put_linkName', 'string') &&
                    Utils::validateField('put_linkUrl', 'string') &&
                    Utils::validateField('put_hairStyleId', 'number') &&
                    Utils::validateField('put_id', 'number')
                ) {
                    $this->id = $_POST['put_id'];
                    $this->hairStyleId = $_POST['put_hairStyleId'];
                    $this->linkUrl = $_POST['put_linkUrl'];
                    $this->linkName = $_POST['put_linkName'];

                    $response = $this->edit();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '404' => 'Hair style link was not found',
                        '500' => 'Could not update hair style link. Please try again later',
                        '200' => 'Hair style link successfully updated'
                    ]);
                }
                break;

            case 'DELETE':
                if (Utils::validateField('delete_id', 'number')) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    return Utils::handleResponse($response, [
                        '404' => 'Hair style link was not found',
                        '400' => 'Invalid hair style link ID',
                        '500' => 'Could not delete hair style link. Please try again later',
                        '200' => 'Hair style link successfully deleted'
                    ]);
                }
                else {
                    return Utils::createAlert('Invalid hair style ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }

        return Utils::createAlert('Invalid fields', 'error');
    }
}