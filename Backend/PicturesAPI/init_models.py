import os
import requests

headers = {
    'accept': 'application/json',
    'Content-Type': 'multipart/form-data'
}

path = os.getcwd() + '\\ModelPicturesSample'

hair_lengths = os.listdir(path)
hair_lengths_dirs = []

for hl in hair_lengths:
    new_path = path + '\\' + hl
    hair_lengths_dirs.append(new_path)

for hl in hair_lengths_dirs:
    for hs in os.listdir(hl):
        for root, directories, files in os.walk(hl, topdown=False):
            for name in files:
                file_info = (os.path.join(root, name).split('\\')[9:12])
                file_request = path + '\\' + file_info[0] + '\\' + file_info[1] + '\\' + file_info[2]
                file = {"file": open(file_request, 'rb')}
                print(file)
                url = "http://localhost:8000/models?hair_length=" + file_info[0] + "&hair_style=" + file_info[1]
                print(url)
                requests.post(url, headers, files=file)
