#! /bin/bash
HOME_DIRECTORY=$(dirname $(readlink -nf $0))
BASE_DIRECTORY=$(dirname ${HOME_DIRECTORY})

guile -L ${BASE_DIRECTORY} -l ${HOME_DIRECTORY}/console-builder.scm -e main -- --home=${HOME_DIRECTORY} 

