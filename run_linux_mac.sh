#!/usr/bin/env bash

export PIPENV_VENV_IN_PROJECT=1

git --version > /dev/null 2>&1
if [ $? != 0 ]
then
    echo Cannot find Git executable, make sure it is installed and added to your PATH.
    read -p "Press [Enter] to exit..."
    exit 0
fi

python3 --version > /dev/null 2>&1
if [ $? != 0 ]
then
    echo Cannot find Python3 executable, make sure it is installed and added to your PATH.
    read -p "Press [Enter] to exit..."
    exit 0
fi

python3 -c "import pipenv" > /dev/null 2>&1
if [ $? != 0 ]
then
    python3 -m pip install --user pipenv
fi

pipenv --version > /dev/null 2>&1
if [ $? != 0 ]
then
    pipenv_path=$(python3 -m site --user-base)/bin
    PATH+=:$pipenv_path
fi

if [ ! -d '.venv' ]
then
    pipenv --bare install
else
    pipenv --bare update
fi

pipenv run python3 -c "exit(__import__('discord').opus.is_loaded())" > /dev/null 2>&1
if [ $? == 0 ]
then
    echo Cannot find libopus on your system, make sure it is installed.
    read -p "Press [Enter] to exit..."
    exit 0
fi

rm panda.log
pipenv run python3 panda.py
