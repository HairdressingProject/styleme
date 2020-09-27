import os
import hashlib
from datetime import datetime
from app.settings import PICTURE_UPLOAD_FOLDER, PICTURE_PROCESSED_FOLDER, FACE_SHAPE_RESULTS_PATH
import pathlib
import shutil
import cv2
from app.libraries.fmPyTorch.utils import Preprocess
from app.libraries.Hair_Style_Recommendation.functions_only_save import make_face_df_save, find_face_shape
import numpy as np
import pandas as pd

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

    
    def detect_face(self, file_name):
        path = PICTURE_UPLOAD_FOLDER
        path_to_file = path + file_name
        pre = Preprocess()
        img = cv2.imread(path_to_file)
        img = cv2.cvtColor(cv2.imread(path_to_file), cv2.COLOR_BGR2RGB)
        face_rgba = pre.process(img)
        if face_rgba is None:
            # delete picture from original folder
            self.delete_picture(path, file_name)
            return False
        else:
            return True

    
    def detect_face_shape(self, file_name):
        path = PICTURE_UPLOAD_FOLDER
        save_path = FACE_SHAPE_RESULTS_PATH
        path_to_file = path + file_name

        df = pd.DataFrame(columns = ['0','1','2','3','4','5','6','7','8','9','10','11',	'12',	'13',	'14',	'15',	'16','17',
                             '18',	'19',	'20',	'21',	'22',	'23',	'24','25',	'26',	'27',	'28',	'29',
                             '30',	'31',	'32',	'33',	'34',	'35',	'36',	'37',	'38',	'39',	'40',	'41',
                             '42',	'43',	'44',	'45',	'46',	'47',	'48',	'49',	'50',	'51',	'52',	'53',
                             '54',	'55',	'56',	'57',	'58',	'59',	'60',	'61',	'62',	'63',	'64',	'65',
                             '66',	'67',	'68',	'69',	'70',	'71',	'72',	'73',	'74',	'75',	'76',	'77',
                             '78',	'79',	'80',	'81',	'82',	'83',	'84',	'85',	'86',	'87',	'88',	'89',
                             '90',	'91',	'92',	'93',	'94',	'95',	'96',	'97',	'98',	'99',	'100',	'101',
                             '102',	'103',	'104',	'105',	'106',	'107',	'108',	'109',	'110',	'111',	'112',	'113',
                             '114',	'115',	'116',	'117',	'118',	'119',	'120',	'121',	'122',	'123',	'124',	'125',
                             '126',	'127',	'128',	'129',	'130',	'131',	'132',	'133',	'134',	'135',	'136',	'137',
                             '138',	'139',	'140',	'141',	'142',	'143','A1','A2','A3','A4','A5','A6','A7','A8','A9',
                            'A10','A11','A12','A13','A14','A15','A16','Width','Height','H_W_Ratio','Jaw_width','J_F_Ratio',
                             'MJ_width','MJ_J_width'])
        print(df)
        photo = path+file_name
        print(photo)
        print(save_path)
        file_num = 2035
        make_face_df_save(photo, file_num, df)
        print(df)
        face_shape = find_face_shape(df, file_num)
        print(face_shape)
        return(face_shape[0])


    def crop_picture(self, file_name):
        original_path = PICTURE_UPLOAD_FOLDER
        processed_path = PICTURE_PROCESSED_FOLDER
        path_to_file = original_path + file_name
        path_to_upload = processed_path + file_name

        print(path_to_file)
        print(path_to_upload)
        img_size = 512
        pre = Preprocess()
        img = cv2.cvtColor(cv2.imread(path_to_file), cv2.COLOR_BGR2RGB)
        face_rgba = pre.process(img)
        face_rgba = cv2.resize(face_rgba, (int(img_size), int(img_size)), interpolation=cv2.INTER_AREA)
        face = face_rgba[:, :, : 3].copy()
        face_crop = face.astype(np.uint8)
        picture_crop = cv2.cvtColor(face_crop, cv2.COLOR_RGB2BGR)
        cv2.imwrite(path_to_upload, picture_crop)

    def delete_picture(self, path, file_name):
        # ToDo: handle exceptions
        os.remove(path+file_name)

    def get_picture_info(self, path, file_name):
        file_name2 = os.path.splitext(path+file_name)[0]
        file_extension = os.path.splitext(path+file_name)[1]
        stats = os.stat(path+file_name)
        file_size = stats.st_size
        # created_at = datetime.fromtimestamp(stats.st_mtime)
        created_at = stats.st_mtime
        print(path, "path")
        print(file_name2, "filename2")
        print(file_extension, "extension")
        print(stats, "stats")
        print(file_size, "file_size")
        print(created_at, "created_at")

        # read uploaded image to retrieve dimensions
        img = cv2.imread(path+file_name, cv2.IMREAD_UNCHANGED)
        dimensions = img.shape
        # print(dimensions)
        height = int(dimensions[0])
        width = int(dimensions[1])

        print(height)
        print(width)

        return (path, file_name, file_size, height, width, created_at)
    