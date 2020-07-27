<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: User.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/
require_once $_SERVER['DOCUMENT_ROOT'] . '/classes/UserRoles.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/actions.php';

class User
{
    public int $id;
    public string $username;
    public string $email;
    public string $password;
    public string $firstName;
    public string $lastName;
    public string $userRole;
    public string $dateCreated;
    public string $dateModified;

    /**
     * Requests the total number of users available in the database
     * @param  string|null  $search Optional search query to count number of results
     * @return array
     */
    public function count(string $search = null)
    {
        if (isset($search)) {
            return countResource('users', $search);
        }
        return countResource('users');
    }

    /**
     * Browses users, with optional pagination
     * @param  int|null  $limit Limit the number of results retrieved
     * @param  int|null  $offset Offset from which results should be retrieved
     * @return array
     */
    public function browse(int $limit = null, int $offset = null)
    {
        $this->sanitise();
        return browseResource('users', $limit, $offset);
    }

    public function read()
    {
        return readResource('users', Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT));
    }

    public function edit()
    {
        return editResource(
            'users',
            array(
                'Id' => Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT),
                'UserName' => Utils::sanitiseField($this->username, FILTER_SANITIZE_STRING),
                'UserEmail' => Utils::sanitiseField($this->email, FILTER_SANITIZE_EMAIL),
                'UserPassword' => $this->password,
                'FirstName' => Utils::sanitiseField($this->firstName, FILTER_SANITIZE_STRING),
                'LastName' => Utils::sanitiseField($this->lastName, FILTER_SANITIZE_STRING),
                'UserRole' => Utils::sanitiseField($this->userRole, FILTER_SANITIZE_STRING)
            )
        );
    }

    public function add()
    {
        return addResource(
            'users',
            array(
                'UserName' => Utils::sanitiseField($this->username, FILTER_SANITIZE_STRING),
                'UserEmail' => Utils::sanitiseField($this->email, FILTER_SANITIZE_EMAIL),
                'UserPassword' => Utils::sanitiseField($this->password, FILTER_SANITIZE_STRING),
                'FirstName' => Utils::sanitiseField($this->firstName, FILTER_SANITIZE_STRING),
                'LastName' => Utils::sanitiseField($this->lastName, FILTER_SANITIZE_STRING),
                'UserRole' => Utils::sanitiseField($this->userRole, FILTER_SANITIZE_STRING)
            )
        );
    }

    public function delete()
    {
        $this->id = Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
        return deleteResource('users', $this->id);
    }

    /**
     * Search based on a given $query, with support for pagination
     * @param string $query Query string to search
     * @param  int|null  $limit Limit the number of results
     * @param  int|null  $offset Offset the results
     * @return array Response from the API
     */
    public function search(string $query, int $limit = null, int $offset = null) {
        return searchResource('users', $query, $limit, $offset);
    }

    /**
     * Sanitises all relevant fields/properties of this class, including the ID
     */
    public function sanitise()
    {
        if (isset($this->id) &&
            isset($this->username) &&
            isset($this->email) &&
            isset($this->firstName) &&
            isset($this->lastName) &&
            isset($this->userRole)
        ) {
            $this->id = Utils::sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
            $this->username = Utils::sanitiseField($this->username, FILTER_SANITIZE_STRING);
            $this->email = Utils::sanitiseField($this->email, FILTER_SANITIZE_EMAIL);
            $this->firstName = Utils::sanitiseField($this->firstName, FILTER_SANITIZE_STRING);
            $this->lastName = Utils::sanitiseField($this->lastName, FILTER_SANITIZE_STRING);
            $this->userRole = Utils::sanitiseField($this->userRole, FILTER_SANITIZE_STRING);

            if ($this->userRole !== 'user' && $this->userRole !== 'developer' && $this->userRole !== 'admin') {
                $this->userRole = 'user';
            }
        }

        // passwords are not sanitised because right now any character is allowed
        // this can be limited in the future
    }

    /**
     * Handles form submission for the users page
     * @param  string  $method  One of: 'POST', 'PUT' or 'DELETE'
     * @return string|null Alert message
     */
    public function handleSubmit($method = 'POST')
    {
        switch ($method) {
            case 'POST':
                if (isset($_POST['add_password']) && isset($_POST['add_confirm_password'])) {
                    if ($_POST['add_password'] === $_POST['add_confirm_password']) {
                        $this->username = $_POST['add_username'];
                        $this->email = $_POST['add_email'];
                        $this->firstName = $_POST['add_first_name'];
                        $this->lastName = $_POST['add_last_name'];
                        $this->password = $_POST['add_password'];
                        $this->userRole = 'user';

                        $response = $this->add();

                        return Utils::handleResponse(
                            $response,
                            [
                                '400' => 'Could not add user: invalid fields',
                                '409' => 'User already exists',
                                '500' => 'Could not add user. Please try again later',
                                '200' => 'User successfully added'
                            ]
                        );
                    } else {
                        // passwords do not match
                        return Utils::createAlert('Passwords do not match', 'error');
                    }
                }
                break;

            case 'PUT':
                if (isset($_POST['put_password']) && isset($_POST['put_confirm_password'])) {
                    if ($_POST['put_password'] === $_POST['put_confirm_password']) {
                        if (isset($_POST['put_id']) && is_numeric($_POST['put_id'])) {
                            $this->id = $_POST['put_id'];
                            $this->username = $_POST['put_username'];
                            $this->email = $_POST['put_user_email'];
                            $this->firstName = $_POST['put_first_name'];
                            $this->lastName = $_POST['put_last_name'];
                            $this->password = $_POST['put_password'];
                            $this->userRole = $_POST['put_user_role'];

                            $response = $this->edit();

                            return Utils::handleResponse(
                                $response,
                                [
                                    '400' => 'Could not edit user: invalid fields',
                                    '409' => 'User already exists',
                                    '500' => 'Could not update user. Please try again later',
                                    '200' => 'User successfully updated'
                                ]
                            );
                        } else {
                            // invalid id
                            return Utils::createAlert('Invalid user ID', 'error');
                        }
                    } else {
                        // passwords do not match
                        return Utils::createAlert('Passwords do not match', 'error');
                    }
                }
                break;

            case 'DELETE':
                if (isset($_POST['delete_id']) && is_numeric($_POST['delete_id'])) {
                    $this->id = intval($_POST['delete_id']);
                    $response = $this->delete();

                    if (isset($response['status'])) {
                        if ($response['status'] === 200) {
                            // user was deleted
                            return Utils::createAlert('User successfully deleted', 'success');
                        } else {
                            return Utils::createAlert('Could not delete user. Please try again later', 'error');
                        }
                    }
                } else {
                    // invalid id
                    return Utils::createAlert('Invalid user ID', 'error');
                }
                break;

            default:
                return Utils::createAlert('Invalid request method', 'error');
        }
        return null;
    }

    /**
     * Updates the current user's account details
     * @return array Results in the format:
     *
     *      $results = [
     *          'oldUser' => old User object
     *          'status' => status code of the response,
     *          'alert' => alert message ready to be printed to the DOM
     *      ]
     *
     */
    public function handleUpdateAccount() {
        $results = [];
        $results['oldUser'] = $this;

        if (
            isset($_POST['username']) &&
            isset($_POST['email']) &&
            isset($_POST['first_name']) &&
            isset($_POST['last_name']) &&
            isset($_POST['password']) &&
            isset($_POST['confirm_password'])
        ) {
            $username = Utils::sanitiseField($_POST['username'], FILTER_SANITIZE_STRING);
            $email = Utils::sanitiseField($_POST['email'], FILTER_SANITIZE_EMAIL);
            $firstName = Utils::sanitiseField($_POST['first_name'], FILTER_SANITIZE_STRING);
            $lastName = Utils::sanitiseField($_POST['last_name'], FILTER_SANITIZE_STRING);

            if ($_POST['password'] !== $_POST['confirm_password']) {
                $results['alert'] = Utils::createAlert('Passwords do not match', 'error');
            }
            else {
                $this->username = $username;
                $this->email = $email;
                $this->firstName = $firstName;
                $this->lastName = $lastName;
                $this->password = $_POST['password'];

                $response = $this->edit();

                $results['alert'] = Utils::handleResponse(
                    $response,
                    [
                        '400' => 'Could not update account: invalid fields',
                        '409' => 'User already exists',
                        '500' => 'Could not update your account. Please try again later',
                        '200' => 'Account successfully updated'
                    ]
                );

                $results['status'] = $response['status'];
            }
        }
        else {
            $results['alert'] = Utils::createAlert('Could not update account: one or more fields are invalid', 'error');
        }

        return $results;
    }
}