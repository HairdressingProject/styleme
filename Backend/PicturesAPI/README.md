# Pictures-API
REST API boilerplate for the hairdressing project

## Instructions
### Create virtual environment
We will be using a conda virtual environment to install all dependencies. To create the environment run: `conda create --name StyleMe python=3.8.5`.

To activate the virtual environment: `conda activate StyleMe`

Then we need to install the following packages:
* Python dotenv:
```shell script
conda install -c conda-forge python-dotenv
```
* FastAPI and Database connector:
```shell script
conda install -c conda-forge fastapi
conda install -c conda-forge orjson
conda install -c conda-forge requests
conda install -c conda-forge sqlalchemy
conda install -c conda-forge uvicorn
conda install -c conda-forge pymysql
conda install -c conda-forge pytest
```

* AWS Services:
```shell script
conda install -c anaconda boto3
```

* Packages to handle image processing and machine learning libraries:
```shell script
conda install -c anaconda pillow
conda install -c conda-forge pandas
conda install -c anaconda scikit-learn
conda install -c conda-forge matplotlib
```

Before installing `dlib` package, we must make sure that we have CMake installed (you can test running `cmake --version`). If not installed, please visit https://cmake.org/install/ and follow the instructions. Then you can install `dlib` library:

```shell script
conda install -c conda-forge dlib
```

* Face recognition library:
```shell script
pip install face_recognition
```

* Face Make Up library:
```shell script
conda install pytorch torchvision cpuonly -c pytorch
conda install -c conda-forge scikit-image
conda install -c conda-forge opencv
```

* fmPyTorch library (used to detect faces):
```shell script
conda install -c 1adrianb face_alignment
```

Download machine learning model (79999_iter.pth):
```shell script
cd app/libraries/fmPytorch/cp
wget https://github.com/zllrunning/face-makeup.PyTorch/raw/master/cp/79999_iter.pth
```

Download the shape predictor (shape_predictor_68_face_landmarks.dat):
```shell script
cd app/libraries/HairTransfer
wget https://github.com/Emmanuel-Ezenwere/HairTransfer/raw/master/shape_predictor_68_face_landmarks.dat
```

### Run the application
From your Anaconda Prompt (with the __StyleMe__ environment activated), run the command below from the project root directory (one level above the `app` directory):

```shell script
uvicorn app.main:app --reload
```

You may now navigate to http://localhost:8000/docs to test the routes available.

#### Running unit tests
From the project root directory, execute:
```shell script
pytest
```