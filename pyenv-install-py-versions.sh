#! /usr/bin/env bash

# On Error - exit 
set -e

# 
py_vers=( 3.8.1  3.7.6  3.6.10  3.5.9 )

echo The following version of python will be installed: ${py_vers[@]}

for ver in ${py_vers[@]}; do 
	pyenv install $ver
done 

pyenv global system ${py_vers[@]}
