<?php
/**********************************************************
 * Package: HairdressingProject
 * Project: Admin-Portal-v2
 * File: Colours.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

class Colours
{
    public int $id;
    public string $colourName;
    public string $colourHash;
    public string $dateCreated;
    public string $dateModified;

    public function browse() {
        return browseResource('colours');
    }

    public function read() {
        return readResource('colours', $this->id);
    }

    public function edit() {
        return editResource('colours', array(
            'Id' => $this->id,
            'ColourName' => $this->colourName,
            'ColourHash' => $this->colourHash
        ));
    }

    public function add() {
        return addResource('colours', array(
            'ColourName' => $this->colourName,
            'ColourHash' => $this->colourHash
        ));
    }

    public function delete() {
        return deleteResource('colours', $this->id);
    }
}