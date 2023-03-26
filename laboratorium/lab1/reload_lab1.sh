#!/bin/bash

SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-2remove}
TARGET_DIR=${3:-bakap}

rm -rf ${SOURCE_DIR}

mkdir ${SOURCE_DIR}
mkdir ${SOURCE_DIR}/folder0
mkdir ${SOURCE_DIR}/folder1
mkdir ${SOURCE_DIR}/folder2
touch ${SOURCE_DIR}/folder0/plik5
touch ${SOURCE_DIR}/folder1/plik6
touch ${SOURCE_DIR}/plik0
touch ${SOURCE_DIR}/plik1
touch ${SOURCE_DIR}/plik2
touch ${SOURCE_DIR}/plik3
touch ${SOURCE_DIR}/plik4

rm -rf ${TARGET_DIR}