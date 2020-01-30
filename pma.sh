#!/bin/bash

PWD=$(pwd)
source "${PWD}/scripts/configs.bash"
source "${PWD}/scripts/out.bash"
source "${PWD}/scripts/logo.bash"
source "${PWD}/scripts/menu.bash"
source "${PWD}/scripts/app.bash"

case ${1} in
    "new") app_new ${@} ;;
    "project") app_project ${@} ;;
    *) menu ;;
esac