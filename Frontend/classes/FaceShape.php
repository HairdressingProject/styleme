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

class FaceShape
{
    public int $id;
    public string $shapeName;
    public string $dateCreated;
    public string $dateModified;

    public function browse() {
        return browseResource('face_shapes');
    }

    public function read() {
        return readResource('face_shapes', $this->id);
    }

    public function edit() {
        return editResource('face_shapes', array(
            'Id' => $this->id,
            'ShapeName' => $this->shapeName,
        ));
    }

    public function add() {
        return addResource('face_shapes', array(
            'ShapeName' => $this->shapeName,
        ));
    }

    public function delete() {
        return deleteResource('face_shapes', $this->id);
    }
}