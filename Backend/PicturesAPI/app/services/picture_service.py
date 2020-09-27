import os
import hashlib
from datetime import datetime
from app.settings import PICTURE_UPLOAD_FOLDER
import pathlib
import shutil
import cv2
from app.libraries.fmPyTorch.utils import Preprocess

class PictureService:
    def save_picture(self, file):
        """
        Saves file on local work directory
        :param file: selected file from folder
        :return: file_info object
        """
        # prepare file info

        file_object = file.file
        file_name = os.path.splitext(file.filename)[0]
        file_extension = os.path.splitext(file.filename)[1]
        # new_filename = str(user_id) + ' - ' + file.filename + ' - ' + str(datetime.now())
        temp_filename = file_name + ' - ' + str(datetime.now())
        hashed_filename = hashlib.md5(temp_filename.encode())
        new_file_name = hashed_filename.hexdigest() + str(file_extension)


        # Save file

        save_file_path = PICTURE_UPLOAD_FOLDER

        if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_file_path)):
            os.makedirs(os.path.join(pathlib.Path().absolute() / save_file_path))
        upload_folder = open(os.path.join(pathlib.Path().absolute() / save_file_path, new_file_name), 'wb+')
        shutil.copyfileobj(file_object, upload_folder)
        upload_folder.close()


        # file stats of the uploaded file (to get file_size and created_at)

        stats = os.stat(save_file_path + new_file_name)
        file_size = stats.st_size
        created_at = datetime.fromtimestamp(stats.st_mtime)

        # read uploaded image to retrieve dimensions
        img = cv2.imread(save_file_path + new_file_name, cv2.IMREAD_UNCHANGED)
        dimensions = img.shape
        print(dimensions)
        height = int(dimensions[0])
        width = int(dimensions[1])


        return (file_name, file_extension, new_file_name, file_size, height, width, created_at)

    
    def detect_face(self, file_name):
        path = PICTURE_UPLOAD_FOLDER
        path_to_file = path + file_name
        pre = Preprocess()
        img = cv2.imread(path_to_file)
        img = cv2.cvtColor(cv2.imread(path_to_file), cv2.COLOR_BGR2RGB)
        face_rgba = pre.process(img)
        if face_rgba is None:
            return False
        else:
            return True
