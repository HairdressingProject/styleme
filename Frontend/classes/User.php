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

require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/browse.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/read.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/edit.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/add.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/actions/delete.php';
require_once $_SERVER['DOCUMENT_ROOT'].'/helpers/utils.php';

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

   public function browse() {
       $this->sanitise();
        return browseResource('users');
   }

   public function read() {
        $this->id = $this->sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
        return readResource('users', $this->id);
   }

   public function edit() {
        $this->sanitise();
        return editResource('users', array(
            'Id' => $this->id,
            'UserName' => $this->username,
            'UserEmail' => $this->email,
            'UserPassword' => $this->password,
            'FirstName' => $this->firstName,
            'LastName' => $this->lastName,
            'UserRole' => $this->userRole
        ));
   }

   public function add() {
        return addResource('users', array(
            'UserName' => $this->sanitiseField($this->username, FILTER_SANITIZE_STRING),
            'UserEmail' => $this->sanitiseField($this->email, FILTER_SANITIZE_EMAIL),
            'UserPassword' => $this->sanitiseField($this->password, FILTER_SANITIZE_STRING),
            'FirstName' => $this->sanitiseField($this->firstName, FILTER_SANITIZE_STRING),
            'LastName' => $this->sanitiseField($this->lastName, FILTER_SANITIZE_STRING),
            'UserRole' => $this->sanitiseField($this->userRole, FILTER_SANITIZE_STRING)
        ));
   }

   public function delete() {
        $this->id = $this->sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
        return deleteResource('users', $this->id);
   }

    /**
     * Sanitises all relevant fields/properties of this class, including the ID
     */
   public function sanitise() {
       if (isset($this->id) &&
           isset($this->username) &&
           isset($this->email) &&
           isset($this->firstName) &&
           isset($this->lastName) &&
           isset($this->userRole)
       ) {
           $this->id = $this->sanitiseField($this->id, FILTER_SANITIZE_NUMBER_INT);
           $this->username = $this->sanitiseField($this->username, FILTER_SANITIZE_STRING);
           $this->email = $this->sanitiseField($this->email, FILTER_SANITIZE_EMAIL);
           $this->firstName = $this->sanitiseField($this->firstName, FILTER_SANITIZE_STRING);
           $this->lastName = $this->sanitiseField($this->lastName, FILTER_SANITIZE_STRING);
           $this->userRole = $this->sanitiseField($this->userRole, FILTER_SANITIZE_STRING);

           if ($this->userRole !== 'user' && $this->userRole !== 'developer' && $this->userRole !== 'admin') {
               $this->userRole = 'user';
           }
       }

       // passwords are not sanitised because right now any character is allowed
       // this can be limited in the future
   }

    /**
     * Sanitises an individual property/field of this class
     * @param $field
     * @param  int  $type ID from the filter constants of filter_var (see docs for more info)
     * @return string
     */
   public function sanitiseField($field, $type) {
       if (isset($field)) {
           return filter_var($field, $type);
       }
       return '';
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
               if (isset($_POST['add_password']) && isset($_POST['add_confirm_password'])) {
                   if ($_POST['add_password'] === $_POST['add_confirm_password']) {
                       $this->username = $_POST['add_username'];
                       $this->email = $_POST['add_email'];
                       $this->firstName = $_POST['add_first_name'];
                       $this->lastName = $_POST['add_last_name'];
                       $this->password = $_POST['add_password'];
                       $this->userRole = 'user';

                       $response = $this->add();

                       if (isset($response['status'])) {
                           switch ($response['status']) {
                               case 400:
                                   // bad request, invalid fields
                                   return Utils::createAlert('Could not add user: invalid fields', 'error');
                                   break;
                               case 409:
                                   // conflict, user already exists
                                   return Utils::createAlert('User already exists', 'error');
                                   break;

                               case 500:
                                   // something went wrong with the API server
                                   return Utils::createAlert('Could not add user. Please try again later', 'error');
                                   break;
                               case 200:
                               case 201:
                                   // all good!
                                   return Utils::createAlert('User successfully added', 'success');
                                   break;
                               default:
                                   // unknown status
                                   break;
                           }
                       }
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

                           if (isset($response['status'])) {
                               switch ($response['status']) {
                                   case 400:
                                       // bad request, invalid fields
                                       return Utils::createAlert('Could not edit user: invalid fields', 'error');
                                       break;
                                   case 409:
                                       // conflict, user already exists
                                       return Utils::createAlert('User already exists', 'error');
                                       break;

                                   case 500:
                                       // something went wrong with the API server
                                       return Utils::createAlert('Could not add user. Please try again later', 'error');
                                       break;
                                   case 200:
                                   case 201:
                                       // all good!
                                       return Utils::createAlert('User successfully updated', 'success');
                                       break;
                                   default:
                                       // unknown status
                                       break;
                               }
                           }
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
                       }
                       else {
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
}