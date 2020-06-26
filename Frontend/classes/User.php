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
        $this->sanitise();
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
       $this->sanitise();
        return addResource('users', array(
            'UserName' => $this->username,
            'UserEmail' => $this->email,
            'UserPassword' => $this->password,
            'FirstName' => $this->firstName,
            'LastName' => $this->lastName,
            'UserRole' => $this->userRole
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
}