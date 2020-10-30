FROM continuumio/miniconda

ARG conda_env=pictures-api
ARG workdir=/api

# Create and activate conda environment (using python 3.8.*)
RUN conda create -n ${conda_env} python=3.8
RUN echo "source activate ${conda_env}" > ~/.bashrc
ENV PATH /opt/conda/envs/${conda_env}/bin:$PATH

WORKDIR ${workdir}

# Upgrade pip
RUN pip install --upgrade pip

# .env
RUN pip install python-dotenv

# App depedencies
RUN pip install fastapi
RUN pip install uvicorn
RUN pip install orjson
RUN pip install requests
RUN pip install SQLAlchemy
RUN pip install PyMySQL
RUN pip install pytest

# AWS
RUN pip install boto3

# CMAKE + DLIB
RUN conda install -c conda-forge cmake
RUN conda install -c conda-forge dlib

# ML dependencies
RUN conda install -c anaconda pillow
RUN conda install -c conda-forge pandas
RUN conda install -c anaconda scikit-learn
RUN conda install -c conda-forge matplotlib

# Face recognition
RUN conda install -c conda-forge face_recognition

# Face makeup
RUN conda install pytorch torchvision cpuonly -c pytorch
RUN conda install -c conda-forge scikit-image
RUN conda install -c conda-forge opencv

# fmPyTorch (for face detection)
RUN conda install -c 1adrianb face_alignment

# Copy everything inside PicturesAPI to the container (inside ${workdir})
COPY . .

# Update system packages and install wget
RUN apt-get update
RUN apt-get install wget

# Download ML model
WORKDIR ${workdir}/app/libraries/fmPytorch/cp
RUN wget https://github.com/zllrunning/face-makeup.PyTorch/raw/master/cp/79999_iter.pth

# Download shape predictor 
WORKDIR ${workdir}/app/libraries/HairTransfer
RUN wget https://github.com/Emmanuel-Ezenwere/HairTransfer/raw/master/shape_predictor_68_face_landmarks.dat

# Move back to ${workdir} and export dependencies installed to 
# requirements.txt (pip) and environment.yml (conda)
WORKDIR ${workdir}
RUN pip freeze > requirements.txt
RUN conda env export -n pictures-api > environment.yml

# Start bash
RUN /bin/bash