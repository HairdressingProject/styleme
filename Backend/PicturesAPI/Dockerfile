FROM continuumio/miniconda3

ARG conda_env=pictures-api
ARG workdir=/api

# Create and activate conda environment (using python 3.8.*)
RUN conda update -n base -c defaults conda && \
    conda create -n ${conda_env} python=3.8 && \
    echo "source activate ${conda_env}" > ~/.bashrc

ENV PATH /opt/conda/envs/${conda_env}/bin:$PATH

WORKDIR ${workdir}

# Copy conda environment file
# COPY environment.yml environment.yml

# Upgrade pip
# .env
# App depedencies
# AWS
RUN pip install --upgrade pip python-dotenv fastapi uvicorn orjson requests SQLAlchemy PyMySQL pytest boto3 python-multipart aiofiles

# Install conda packages
# CMAKE + DLIB
RUN conda install -n ${conda_env} -c conda-forge cmake && \
    conda install -n ${conda_env} -c conda-forge dlib && \
    # ML dependencies
    conda install -n ${conda_env} -c anaconda pillow && \
    conda install -n ${conda_env} -c conda-forge pandas && \
    conda install -n ${conda_env} -c anaconda scikit-learn && \
    conda install -n ${conda_env} -c conda-forge matplotlib && \
    # Face recognition
    conda install -n ${conda_env} -c conda-forge face_recognition && \
    # Face makeup   
    conda install -n ${conda_env} pytorch torchvision cpuonly -c pytorch && \
    conda install -n ${conda_env} -c conda-forge scikit-image && \
    conda install -n ${conda_env} -c conda-forge opencv && \
    # fmPyTorch (for face detection)
    conda install -n ${conda_env} -c 1adrianb face_alignment

# Copy everything inside PicturesAPI to the container (inside ${workdir})
COPY . .

# Uncomment the commands below to download ML model and shape predictor only if you have to
# It should already be available in the container from the previous COPY command

# Update system packages and install wget
RUN apt-get update && apt-get install -y wget && apt-get install -y libgl1-mesa-dev

# Download ML model
WORKDIR ${workdir}/app/libraries/fmPytorch/cp
RUN wget https://github.com/zllrunning/face-makeup.PyTorch/raw/master/cp/79999_iter.pth

# Download shape predictor 
WORKDIR ${workdir}/app/libraries/HairTransfer
RUN wget https://github.com/Emmanuel-Ezenwere/HairTransfer/raw/master/shape_predictor_68_face_landmarks.dat

# Move back to ${workdir} and export dependencies installed to 
# requirements.txt (pip) and environment.yml (conda)
WORKDIR ${workdir}
RUN pip freeze > requirements.txt && \
    conda env export -n pictures-api > environment.yml

# Start bash
# RUN /bin/bash

# Use the command below in docker-compose to create a new environment based on the environment.yml file
# conda env create -f environment.yml -n pictures-api python=3.8

# Installing pip packages afterwards
# pip install -r requirements.txt