# Run the code below ONLY on Windows
# Also, change the URL to http://22.22.22.5:8000 if you're running this on a Docker container

""" import os
import requests

i = 0
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
    print("************************************************************************************************")
    print(hl)
    print("************************************************************************************************")
    for root, directories, files in os.walk(hl, topdown=False):
        for name in files:
            i += 1
            dirs = len(os.path.join(root, name).split('\\'))
            file_info = (os.path.join(root, name).split('\\')[dirs - 3:dirs])
            file_request = path + '\\' + file_info[0] + '\\' + file_info[1] + '\\' + file_info[2]
            file = {"file": open(file_request, 'rb')}
            print(file)
            url = "http://localhost:8000/models?hair_length=" + file_info[0] + "&hair_style=" + file_info[1]
            print(url)
            requests.post(url, headers, files=file)
            print(i) """

# The code below only works on Linux!
# Uncomment it and comment out the previous one if you're on Linux
# Also, change the URL to http://22.22.22.5:8000 if you're running this on a Docker container
import os
import requests
i = 0
headers = {
    'Accept': 'application/json',
    'Content-Type': 'multipart/form-data'
}

path = os.getcwd() + '/ModelPicturesSample'

hair_lengths = os.listdir(path)
hair_lengths_dirs = []

for hl in hair_lengths:
    new_path = path + '/' + hl
    hair_lengths_dirs.append(new_path)

for hl in hair_lengths_dirs:
    print("************************************************************************************************")
    print(hl)
    print("************************************************************************************************")
    for root, directories, files in os.walk(hl, topdown=False):
        for name in files:
            i += 1
            dirs = len(os.path.join(root, name).split('/'))
            file_info = (os.path.join(root, name).split('/')[dirs-3:dirs])
            file_request = path + '/' + file_info[0] + '/' + file_info[1] + '/' + file_info[2]
            with open(file_request, 'rb') as f:
                file = {"file": f}
                print(file)
                url = "http://22.22.22.5:8000/models?hair_length=" + file_info[0] + "&hair_style=" + file_info[1]
                print(url)
                r = requests.post(url, headers, files=file)
                print('Request headers: ' + str(r.request.headers))
                print('Response headers: ' + str(r.headers))
                print('Response status: ' + str(r.status_code))
                print('Response body: ' + str(r.json()))
                print(i)
