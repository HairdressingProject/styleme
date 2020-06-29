<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: UserFeature.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-28
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/actions.php';

require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/User.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/FaceShape.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/SkinTone.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/HairStyle.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/HairLength.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/Colour.php';

class UserFeature
{
    public int $id;
    public int $userId;
    public int $faceShapeId;
    public int $skinToneId;
    public int $hairStyleId;
    public int $hairLengthId;
    public int $hairColourId;
    public string $dateCreated;
    public string $dateModified;

    public User $user;
    public FaceShape $faceShape;
    public SkinTone $skinTone;
    public HairStyle $hairStyle;
    public HairLength $hairLength;
    public Colour $hairColour;

    /**
     * Requests the total number of user features available in the database
     * @return array
     */
    public function count()
    {
        return countResource('user_features');
    }

    /**
     * Browses user features, with optional pagination
     * @param  int|null  $limit Limit the number of results retrieved
     * @param  int|null  $offset Offset from which results should be retrieved
     * @return array
     */
    public function browse(int $limit = null, int $offset = null)
    {
        return browseResource('user_features', $limit, $offset);
    }

    public function read() {
        return readResource('user_features', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit() {
        return editResource('user_features', array(
            'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
            'UserId' => Utils::sanitiseField($this->userId, FILTER_SANITIZE_NUMBER_INT),
            'FaceShapeId' => Utils::sanitiseField($this->faceShapeId, FILTER_SANITIZE_NUMBER_INT),
            'SkinToneId' => Utils::sanitiseField($this->skinToneId, FILTER_SANITIZE_NUMBER_INT),
            'HairStyleId' => Utils::sanitiseField($this->hairStyleId, FILTER_SANITIZE_NUMBER_INT),
            'HairLengthId' => Utils::sanitiseField($this->hairLengthId, FILTER_SANITIZE_NUMBER_INT),
            'HairColourId' => Utils::sanitiseField($this->hairColourId, FILTER_SANITIZE_NUMBER_INT)
        ));
    }

    public function add() {
        return addResource('user_features', array(
            'UserId' => Utils::sanitiseField($this->userId, FILTER_SANITIZE_NUMBER_INT),
            'FaceShapeId' => Utils::sanitiseField($this->faceShapeId, FILTER_SANITIZE_NUMBER_INT),
            'SkinToneId' => Utils::sanitiseField($this->skinToneId, FILTER_SANITIZE_NUMBER_INT),
            'HairStyleId' => Utils::sanitiseField($this->hairStyleId, FILTER_SANITIZE_NUMBER_INT),
            'HairLengthId' => Utils::sanitiseField($this->hairLengthId, FILTER_SANITIZE_NUMBER_INT),
            'HairColourId' => Utils::sanitiseField($this->hairColourId, FILTER_SANITIZE_NUMBER_INT)
        ));
    }

    public function delete() {
        return deleteResource('user_features', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    /**
     * Handles form submission for the user features page
     * @param  string  $method One of: 'POST', 'PUT' or 'DELETE'
     * @return string|null Alert message
     */
    public function handleSubmit($method = 'POST')
    {
        switch ($method) {
            case 'POST':
                var_dump(Utils::validateField('add_userId', 'number'));
//                if (Utils::validateField('add_userId', 'number') &&
//                    Utils::validateField('add_faceShapeId', 'number') &&
//                    Utils::validateField('add_skinToneId', 'number') &&
//                    Utils::validateField('add_hairStyleId', 'number') &&
//                    Utils::validateField('add_hairLengthId', 'number') &&
//                    Utils::validateField('add_hairColourId', 'number')
//                ) {
                    $this->userId = $_POST['add_userId'];
                    $this->faceShapeId = $_POST['add_faceShapeId'];
                    $this->skinToneId = $_POST['add_skinToneId'];
                    $this->hairStyleId = $_POST['add_hairStyleId'];
                    $this->hairLengthId = $_POST['add_hairLengthId'];
                    $this->hairColourId = $_POST['add_hairColourId'];

                    $response = $this->add();

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '500' => 'Could not add user feature. Please try again later',
                        '200' => 'User feature successfully added'
                    ]);
//                }
                break;

            case 'PUT':
                if (
                    Utils::validateField('put_id', 'number') &&
                    Utils::validateField('put_userId', 'number') &&
                    Utils::validateField('put_faceShapeId', 'number') &&
                    Utils::validateField('put_skinToneId', 'number') &&
                    Utils::validateField('put_hairStyleId', 'number') &&
                    Utils::validateField('put_hairLengthId', 'number') &&
                    Utils::validateField('put_hairColourId', 'number')
                ) {
                    $this->id = $_POST['put_id'];
                    $this->userId = $_POST['put_userId'];
                    $this->faceShapeId = $_POST['put_faceShapeId'];
                    $this->skinToneId = $_POST['put_skinToneId'];
                    $this->hairStyleId = $_POST['put_hairStyleId'];
                    $this->hairLengthId = $_POST['put_hairLengthId'];
                    $this->hairColourId = $_POST['put_hairColourId'];

                    $response = $this->edit();
                    var_dump($response);

                    return Utils::handleResponse($response, [
                        '400' => 'Invalid fields',
                        '404' => 'user feature was not found',
                        '500' => 'Could not update user feature. Please try again later',
                        '200' => 'User feature successfully updated'
                    ]);
                }
                break;

            case 'DELETE':
                if (Utils::validateField('delete_id', 'number')) {
                    $this->id = $_POST['delete_id'];

                    $response = $this->delete();

                    return Utils::handleResponse($response, [
                        '404' => 'user feature was not found',
                        '400' => 'Invalid user feature ID',
                        '500' => 'Could not delete user feature. Please try again later',
                        '200' => 'User feature successfully deleted'
                    ]);
                }
                else {
                    return Utils::createAlert('Invalid user feature ID field', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }

        return Utils::createAlert('Invalid fields', 'error');
    }
}