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
                dirs = len(os.path.join(root, name).split('\\'))
                file_info = (os.path.join(root, name).split('\\')[dirs-3:dirs])
                file_request = path + '\\' + file_info[0] + '\\' + file_info[1] + '\\' + file_info[2]
                file = {"file": open(file_request, 'rb')}
                print(file)
                url = "http://localhost:8000/models?hair_length=" + file_info[0] + "&hair_style=" + file_info[1]
                print(url)
                # requests.post(url, headers, files=file)
