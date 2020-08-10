#!/bin/bash

PWD=$(pwd)

if [ -e "${PWD}/helpers/env.bash" ]; then
    source "${PWD}/helpers/env.bash"
fi
source "${PWD}/helpers/configs.bash"
source "${PWD}/helpers/colors.bash"
source "${PWD}/helpers/out.bash"
source "${PWD}/helpers/logo.bash"
source "${PWD}/helpers/menu.bash"
source "${PWD}/src/app.bash"

case ${1} in
    "install") app_install ;;
    "new") app_new ${@} ;;
    "list") app_register ${@} ;;
    "project") app_project ${@} ;;
    "clear") app_clear ;;
    *) menu ;;
esac