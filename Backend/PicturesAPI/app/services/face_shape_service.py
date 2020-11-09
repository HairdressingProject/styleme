class FaceShapeService:
    face_shape_dict = {"heart": 1, "square": 2, "round": 3, "oval": 4, "long": 5}

    def parse_face_shape(self, face_shape):
        """
        Parse face shape int to string
        :param face_shape: ID of the selected face shape
        :return: face shape name
        """
        face_shape_id = self.face_shape_dict[face_shape]
        return face_shape_id
