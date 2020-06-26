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

class User
{
    public int $id;
    public string $username;
    public string $email;
    public string $password;
    public string $first_name;
    public string $last_name;

   public function browse() {
        return browseResource('users');
   }

   public function read() {

   }

   public function edit() {

   }

   public function add() {

   }

   public function delete() {

   }
}