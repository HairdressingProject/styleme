import os
import hashlib
from datetime import datetime
import face_recognition
from app.models import Picture
from app.models import ModelPicture
from app.settings import PICTURE_UPLOAD_FOLDER, FACE_SHAPE_RESULTS_PATH, HAIR_COLOUR_RESULTS_PATH
import pathlib
import shutil
import cv2
from app.libraries.fmPyTorch.utils import Preprocess
from app.libraries.fmPyTorch.test import evaluate
from app.libraries.fmPyTorch.makeup import hair
from app.libraries.Hair_Style_Recommendation.functions_only_save import make_face_df_save, find_face_shape
import numpy as np
import pandas as pd

from app.libraries.HairTransfer.QuantumProcessor import perform_swap
from app import schemas


class PictureService:
    def save_picture(self, file, save_file_path=PICTURE_UPLOAD_FOLDER):
        """
        Saves file on local work directory
        :param save_file_path: str: 'foo/bar', DEFAULT=import PICTURE_UPLOAD_FOLDER
        :param file: selected file from folder
        :return: new_file_name ('23Dc9498897c27c1a1778fb41ce680aS.jpg')
        """

        file_object = file.file
        file_name = os.path.splitext(file.filename)[0]
        file_extension = os.path.splitext(file.filename)[1]
        # new_filename = str(user_id) + ' - ' + file.filename + ' - ' + str(datetime.now())
        temp_filename = file_name + ' - ' + str(datetime.now())
        hashed_filename = hashlib.md5(temp_filename.encode())
        new_file_name = hashed_filename.hexdigest() + str(file_extension)

        # Save file

        # save_file_path = PICTURE_UPLOAD_FOLDER

        if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_file_path)):
            os.makedirs(os.path.join(pathlib.Path().absolute() / save_file_path))
        upload_folder = open(os.path.join(pathlib.Path().absolute() / save_file_path, new_file_name), 'wb+')
        shutil.copyfileobj(file_object, upload_folder)
        upload_folder.close()

        # file stats of the uploaded file (to get file_size and created_at)
        # stats = os.stat(save_file_path + new_file_name)
        # file_size = stats.st_size
        # created_at = datetime.fromtimestamp(stats.st_mtime)

        # read uploaded image to retrieve dimensions
        # img = cv2.imread(save_file_path + new_file_name, cv2.IMREAD_UNCHANGED)
        # dimensions = img.shape
        # print(dimensions)
        # height = int(dimensions[0])
        # width = int(dimensions[1])

        return (new_file_name)

    def detect_face(self, file_name, file_path=PICTURE_UPLOAD_FOLDER):
        """
        Detects if a picture contains at least one face
        :param file_name: str: hashed_file_name ('23Dc9498897c27c1a1778fb41ce680aS.jpg')
        :param file_path: str: 'foo/bar', DEFAULT=PICTURE_UPLOAD_FOLDER
        :return: boolean
        """

        pre = Preprocess()
        # img = cv2.imread(path_to_file)
        try:
            img = cv2.cvtColor(cv2.imread(file_path + file_name), cv2.COLOR_BGR2RGB)
        except:
            print("Could not process image")
            self.delete_picture(file_path, file_name)
            return False
        face_rgba = pre.process(img)
        if face_rgba is None:
            # delete picture from original folder
            self.delete_picture(file_path, file_name)
            return False
        else:
            return True

    def detect_face_landmarks(self, file_name, file_path=PICTURE_UPLOAD_FOLDER):
        """
        Detects landmark points on face
        :param file_name: str: hashed_file_name ('23Dc9498897c27c1a1778fb41ce680aS.jpg')
        :param file_path: str: 'foo/bar', DEFAULT=PICTURE_UPLOAD_FOLDER
        :return: None or [] face_landmark_list
        """
        image = face_recognition.load_image_file(file_path + file_name)
        face_landmarks_list = face_recognition.face_landmarks(image)

        print("I found {} face(s) in this photograph.".format(len(face_landmarks_list)))
        if len(face_landmarks_list) == 0:
            print("error")
            self.delete_picture(file_path, file_name)
            return None
        else:
            return face_landmarks_list

    def detect_face_shape(self, file_name, file_path=PICTURE_UPLOAD_FOLDER, save_path=PICTURE_UPLOAD_FOLDER):
        """
        Predicts face shape from a picture
        :param file_name: str: hashed_file_name ('23Dc9498897c27c1a1778fb41ce680aS.jpg')
        :param file_path: str: 'foo/bar', DEFAULT=PICTURE_UPLOAD_FOLDER
        :param save_path: str: (optional) 'foo/bar', DEFAULT=PICTURE_UPLOAD_FOLDER
        :return: str: Face shape or Error message
        """
        save_path = FACE_SHAPE_RESULTS_PATH

        if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_path)):
            os.makedirs(os.path.join(pathlib.Path().absolute() / save_path))

        df = pd.DataFrame(
            columns=['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17',
                     '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29',
                     '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41',
                     '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53',
                     '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65',
                     '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77',
                     '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89',
                     '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101',
                     '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113',
                     '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125',
                     '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137',
                     '138', '139', '140', '141', '142', '143', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9',
                     'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'Width', 'Height', 'H_W_Ratio', 'Jaw_width',
                     'J_F_Ratio',
                     'MJ_width', 'MJ_J_width'])

        # print(file_path, "file_path")
        # print(file_name, "file_name")
        # print(save_path, "save_path")

        face_landmarks_list = self.detect_face_landmarks(file_name, file_path)
        # print(face_landmarks_list)
        if face_landmarks_list is None:
            # return ("No landmarks found")
            self.delete_picture(file_path, file_name)
            print("No landmarks found")
            return None

        file_num = 2035

        # generate data frame with the new picture information
        file_url = file_path + file_name
        # make_face_df_save(file_url, file_num, df)
        make_face_df_save(file_path, file_name, save_path, file_num, df)

        # run model to predict the face shape
        face_shape = find_face_shape(df, file_num)

        return (face_shape)

    def crop_picture(self, file_path, file_name, save_path):
        """
        crop a picture, using fmPytorch library
        :param file_url: str: complete path to file ('foo/bar.jpg')
        :return: void
        """
        # original_path = PICTURE_UPLOAD_FOLDER
        # processed_path = PICTURE_PROCESSED_FOLDER
        # path_to_file = original_path + file_name
        # # path_to_upload = processed_path + file_name
        # path_to_upload = original_path + file_name + "_NEW_cropped.jpg"

        new_file_name = file_name.split('.')[0]
        new_file_extension = file_name.split('.')[1]

        img_size = 512
        pre = Preprocess()
        img = cv2.cvtColor(cv2.imread(file_path + file_name), cv2.COLOR_BGR2RGB)
        face_rgba = pre.process(img)
        face_rgba = cv2.resize(face_rgba, (int(img_size), int(img_size)), interpolation=cv2.INTER_AREA)
        face = face_rgba[:, :, : 3].copy()
        face_crop = face.astype(np.uint8)
        picture_crop = cv2.cvtColor(face_crop, cv2.COLOR_RGB2BGR)
        cv2.imwrite(save_path + new_file_name + "_cropped." + new_file_extension, picture_crop)

    def crop_picture_data(self, file_name):

        img_size = 512
        pre = Preprocess()
        img = cv2.cvtColor(cv2.imread(file_name.as_posix()), cv2.COLOR_BGR2RGB)
        face_rgba = pre.process(img)
        face_rgba = cv2.resize(face_rgba, (int(img_size), int(img_size)), interpolation=cv2.INTER_AREA)
        face = face_rgba[:, :, : 3].copy()
        face_crop = face.astype(np.uint8)
        picture_crop = cv2.cvtColor(face_crop, cv2.COLOR_RGB2BGR)
        cv2.imwrite(file_name.as_posix() + "_NEW_cropped.jpg", picture_crop)

    def delete_picture(self, path, file_name):
        """
        Delete a picture file
        :param path: path to selected file
        :param file_name: selected file name
        :return: void
        """
        if os.path.exists(os.path.join(path, file_name)):
            os.remove(path + file_name)

    def get_picture_info(self, path, file_name) -> schemas.PictureInfo:
        """
        Retrieve information about file
        :param file_name: selected file name
        :param path: path to selected file
        :return: tuple: (path, file_name, file_size, height, width, created_at)
        """
        # file_name2 = os.path.splitext(path + file_name)[0]
        # file_extension = os.path.splitext(path + file_name)[1]
        stats = os.stat(path + file_name)
        file_size = stats.st_size
        # created_at = datetime.fromtimestamp(stats.st_mtime)
        created_at = stats.st_mtime
        # print(path, "path")
        # print(file_name2, "filename2")
        # print(file_extension, "extension")
        # print(stats, "stats")
        # print(file_size, "file_size")
        # print(created_at, "created_at")

        # read uploaded image to retrieve dimensions
        img = cv2.imread(path + file_name, cv2.IMREAD_UNCHANGED)
        dimensions = img.shape
        # print(dimensions)
        height = int(dimensions[0])
        width = int(dimensions[1])

        # print(height)
        # print(width)

        picture_info: schemas.PictureInfo = schemas.PictureInfo(file_path=path, file_name=file_name, height=height,
                                                                width=width, created_at=created_at, file_size=file_size)
        return picture_info

    def change_hair_colour(self, file_name, selected_colour, file_path=PICTURE_UPLOAD_FOLDER,
                           save_path=HAIR_COLOUR_RESULTS_PATH):
        """
        Currently this function is not used
        :param file_name:
        :param selected_colour:
        :param file_path:
        :param save_path:
        :return:
        """

        if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_path)):
            os.makedirs(os.path.join(pathlib.Path().absolute() / save_path))

        table = {'hair': 17, 'upper_lip': 12, 'lower_lip': 13}
        cp = 'app/libraries/fmPytorch/cp/79999_iter.pth'

        img_url = file_path + file_name  # @param {type: "string"}
        print(img_url)

        img_size = "512"  # @param [512,256]
        img = cv2.cvtColor(cv2.imread(img_url), cv2.COLOR_BGR2RGB)
        pre = Preprocess()
        face_rgba = pre.process(img)

        if face_rgba is not None:
            # change background to white
            face_rgba = cv2.resize(face_rgba, (int(img_size), int(img_size)), interpolation=cv2.INTER_AREA)
            # face = face_rgba[:, :, : 3].copy()
            # mask = face_rgba[:, :, 3].copy()[:, :, np.newaxis] / 255.
            # face_white_bg = (face * mask + (1 - mask) * 255).astype(np.uint8)
            # potrait = cv2.cvtColor(face_white_bg, cv2.COLOR_RGB2BGR)
            portrait = cv2.cvtColor(face_rgba, cv2.COLOR_RGB2BGR)
            cv2.imwrite('pictures/hair_colour/portrait.png', portrait)

        # cv2.imwrite('pictures/hair_colour/test.png', img)
        # print(img)

        parsing = evaluate(portrait, cp)
        part = [table['hair']]

        colours = {"tropical_green": [56, 86, 37], "sunny_yellow": [38, 231, 249], "juicy_orange": [38, 97, 236], "fiery_red": [68, 12, 184],
                   "hot_pink": [177, 52, 207], "mysterious_violet": [135, 45, 64], "ocean_blue": [122, 60, 1], "jet_black": [28, 34, 39]}


        image = hair(portrait, parsing, part, colours[str(selected_colour)])

        # cv2.imwrite('pictures/hair_colour/makeup.png', image)
        new_file_name = file_name.split('.')[0] + '_' + str(selected_colour) + '.' + file_name.split('.')[1]
        full_path = save_path + new_file_name
        print(full_path, "full path")
        cv2.imwrite(full_path, image)
        picture_info = PictureService.get_picture_info(self, save_path, new_file_name)
        print(picture_info)

        return picture_info

    def change_hair_colour_RGB(self, file_name, r, b, g, file_path=PICTURE_UPLOAD_FOLDER,
                               save_path=HAIR_COLOUR_RESULTS_PATH):
        """
        Change hair colour of a selected picture
        :param file_name: selected file name
        :param r: Red value of RGB color model
        :param b: Blue value of RGB color model
        :param g: Green value of RGB color model
        :param file_path: path to selected picture to apply colour
        :param save_path: path to where the changed colour file should be saved
        :return: new picture file information
        """

        if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_path)):
            os.makedirs(os.path.join(pathlib.Path().absolute() / save_path))

        table = {'hair': 17, 'upper_lip': 12, 'lower_lip': 13}
        # ToDo: on a Linux OS, the path to this file must be a full path, not a relative path
        cp = 'app/libraries/fmPytorch/cp/79999_iter.pth'

        img_url = file_path + file_name  # @param {type: "string"}
        print(img_url)

        img_size = "512"  # @param [512,256]
        img = cv2.cvtColor(cv2.imread(img_url), cv2.COLOR_BGR2RGB)
        pre = Preprocess()
        face_rgba = pre.process(img)

        if face_rgba is not None:
            # change background to white
            face_rgba = cv2.resize(face_rgba, (int(img_size), int(img_size)), interpolation=cv2.INTER_AREA)
            portrait = cv2.cvtColor(face_rgba, cv2.COLOR_RGB2BGR)
            cv2.imwrite('pictures/hair_colour/portrait.png', portrait)

        # cv2.imwrite('pictures/hair_colour/test.png', img)
        # print(img)

        parsing = evaluate(portrait, cp)
        part = [table['hair']]

        selected_colour2 = [b, g, r]

        image = hair(portrait, parsing, part, selected_colour2)

        temp_filename = file_name + ' - ' + str(datetime.now())
        hashed_filename = hashlib.md5(temp_filename.encode())
        file_extension = str('.' + file_name.split('.')[1])
        new_file_name = hashed_filename.hexdigest() + file_extension

        # new_file_name = file_name.split('.')[0] + '_' + str(selected_colour) + 'R_' + str(r) + 'B_' + str(b) + 'G_' + str(g) + '.' + file_name.split('.')[1]
        full_path = save_path + new_file_name
        print(full_path)
        print(full_path, "full path")
        cv2.imwrite(full_path, image)
        picture_info = PictureService.get_picture_info(self, save_path, new_file_name)
        print(picture_info)

        return picture_info

    def change_hairstyle(self, user_picture: Picture, model_picture: ModelPicture):
        """
        Change a user hairstyle depending on the selected model hairstyle
        :param user_picture: selected user Picture class instance
        :param model_picture: selected ModelPicture class instance
        :return: picture information of the generated file
        """

        print(user_picture.file_path + user_picture.file_name, "User picture")
        print(model_picture.file_path + model_picture.file_name, "Model picture")

        class hair_transfer_request(object):
            def __init__(self, user_picture, model_picture):
                self.selfie = cv2.imread(user_picture.file_path + user_picture.file_name)
                self.hair_model = cv2.imread(model_picture.file_path + model_picture.file_name)
                self.files = {'selfie': self.selfie, 'hair_model': self.hair_model}

                self.form = {'username': user_picture.file_path + user_picture.file_name,
                             'uploader': model_picture.file_path + model_picture.file_name}

        request_obj = hair_transfer_request(user_picture, model_picture)

        result = perform_swap(request_obj)
        picture_info = PictureService.get_picture_info(self, result[0], result[1])
        print(picture_info, "picture info")
        return picture_info

    def change_hairstyle_str(self, user_picture: str, model_picture: str):
        """
        Currently this function is not being used
        :param user_picture:
        :param model_picture:
        :return:
        """

        class hair_transfer_request(object):
            def __init__(self, user_picture, model_picture):
                print(user_picture)
                print(model_picture)
                self.selfie = cv2.imread(PICTURE_UPLOAD_FOLDER + user_picture)
                self.hair_model = cv2.imread(PICTURE_UPLOAD_FOLDER + model_picture)
                self.files = {'selfie': self.selfie, 'hair_model': self.hair_model}
                self.form = {'username': user_picture, 'uploader': model_picture}

        request_obj = hair_transfer_request(user_picture, model_picture)

        perform_swap(request_obj)

    def change_hairstyle_str_path(self, user_picture: str, model_picture: str):
        """
        Currently this function is not being used
        :param user_picture:
        :param model_picture:
        :return:
        """

        class hair_transfer_request(object):
            def __init__(self, user_picture, model_picture):
                print(user_picture)
                print(model_picture)
                self.selfie = cv2.imread('pictures/face_shape/' + user_picture)
                self.hair_model = cv2.imread('pictures/face_shape/' + model_picture)
                self.files = {'selfie': self.selfie, 'hair_model': self.hair_model}
                self.form = {'username': user_picture, 'uploader': model_picture}

        request_obj = hair_transfer_request(user_picture, model_picture)

        perform_swap(request_obj)
