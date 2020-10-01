class FaceShapeService:
    face_shape_dict = {"heart": 1, "square": 2, "round": 3, "oval": 4, "long": 5}

    def parse_face_shape(self, face_shape):
        face_shape_id = self.face_shape_dict[face_shape]
        return face_shape_id
