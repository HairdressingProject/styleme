<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: HairLengthLink.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-28
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/actions.php';

class HairLengthLink
{
    public int $id;
    public int $hairLengthId;
    public string $linkName;
    public string $linkUrl;
    public string $dateCreated;
    public string $dateModified;

    public HairLength $hairLength;

    /**
     * Requests the total number of hair length links available in the database
     * @return array
     */
    public function count()
    {
        return countResource('hair_length_links');
    }

    /**
     * Browses hair length links, with optional pagination
     * @param  int|null  $limit Limit the number of results retrieved
     * @param  int|null  $offset Offset from which results should be retrieved
     * @return array
     */
    public function browse(int $limit = null, int $offset = null)
    {
        return browseResource('hair_length_links', $limit, $offset);
    }

    public function read() {
        return readResource('hair_length_links', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('hair_length_links', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'HairLengthId' => Utils::sanitiseField($this->hairLengthId, FILTER_SANITIZE_NUMBER_INT),
            'LinkName' => Utils::sanitiseField($this->linkName, FILTER_SANITIZE_STRING),
            'LinkUrl' => Utils::sanitiseField($this->linkUrl, FILTER_SANITIZE_URL)
        ));
    }

    public function add() {
        return addResource('hair_length_links', array(
            'HairLengthId' => Utils::sanitiseField($this->hairLengthId, FILTER_SANITIZE_NUMBER_INT),
            'LinkName' => Utils::sanitiseField($this->linkName, FILTER_SANITIZE_STRING),
            'LinkUrl' => Utils::sanitiseField($this->linkUrl, FILTER_SANITIZE_URL)
        ));
    }

    public function delete() {
        return deleteResource('hair_length_links', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
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
                    Utils::validateField('add_hairLengthId', 'number')
                ) {
                    $this->hairLengthId = $_POST['add_hairLengthId'];
                    $this->linkUrl = $_POST['add_linkUrl'];
                    $this->linkName = $_POST['add_linkName'];

                    $response = $this->add();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '500' => 'Could not add hair length link. Please try again later',
                        '200' => 'Hair length link successfully added'
                    ]);
                }
                break;

            case 'PUT':
                if (
                    Utils::validateField('put_linkName', 'string') &&
                    Utils::validateField('put_linkUrl', 'string') &&
                    Utils::validateField('put_hairLengthId', 'number') &&
                    Utils::validateField('put_id', 'number')
                ) {
                    $this->id = $_POST['put_id'];
                    $this->hairLengthId = $_POST['put_hairLengthId'];
                    $this->linkUrl = $_POST['put_linkUrl'];
                    $this->linkName = $_POST['put_linkName'];

                    $response = $this->edit();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '404' => 'Hair length link was not found',
                        '500' => 'Could not update hair length link. Please try again later',
                        '200' => 'Hair length link successfully updated'
                    ]);
                }
                break;

            case 'DELETE':
                if (Utils::validateField('delete_id', 'number')) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    return Utils::handleResponse($response, [
                        '404' => 'Hair length link was not found',
                        '400' => 'Invalid hair length link ID',
                        '500' => 'Could not delete hair length link. Please try again later',
                        '200' => 'Hair length link successfully deleted'
                    ]);
                }
                else {
                    return Utils::createAlert('Invalid hair length ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }

        return Utils::createAlert('Invalid fields', 'error');
    }
}