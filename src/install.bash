app_install()
{
    app_install_login

    app_install_project

    app_install_activity

    app_install_description

    app_install_generate_config
}

app_install_login()
{
    echo -e $CL_YELLOW"Informe seu login do PMA:$CL_DEFAULT"
    read -p "Login: " INPUT_LOGIN
    echo

    echo -e $CL_YELLOW"Informe sua senha do PMA:$CL_DEFAULT"
    read -s -p "Senha: " INPUT_PASSWORD
    echo

    echo > $CURL_RESPONSE_FILE

    echo -e $CL_DEFAULT"Por favor aguarde, validando login e senha...$CL_DEFAULT"
    curl -s -c $COOKIE_FILE POST {$URL}/login/login -F "usuario[login]=$INPUT_LOGIN" -F "usuario[senha]=$INPUT_PASSWORD" > $CURL_RESPONSE_FILE

    RESPONSE=$(cat $CURL_RESPONSE_FILE | grep formlogin)

    if [ ! -z "$RESPONSE" ] ; then
        out "$CL_RED
Login / Senha inválidos.
Por favor, tente novamente.
        "
        app_install_login
    else
        out "$CL_GREN
Aunticação realizada com sucesso!
        "
    fi
}

app_install_project()
{
    echo -e $CL_YELLOW"Informe o código do projeto abaixo que deseja utilizar como padrão:$CL_DEFAULT"

    app_project_list

    echo
    read -p "Cód. do Projeto: " INPUT_COD_PROJECT
    echo

    PROJECT_DEFAULT_DESC=$(app_project_list | sed -e 's/\t//g' | grep "$INPUT_COD_PROJECT |" | cut -d '|' -f2 | xargs echo -n)
}

app_install_activity()
{
    echo -e $CL_YELLOW"Informe o código da atividade abaixo que deseja utilizar como padrão:$CL_DEFAULT"
    
    app_project_items $INPUT_COD_PROJECT
    
    echo
    read -p "Cód. da Atividade: " INPUT_COD_ACTIVITY
    echo

    ACTIVITY_DEFAULT_DESC=$(app_project_items $INPUT_COD_PROJECT | sed -e 's/\t//g' | grep "$INPUT_COD_ACTIVITY |" | cut -d '|' -f2 | xargs echo -n)
}

app_install_description()
{
    echo -e $CL_YELLOW"Informe uma descrição padrão que deseja utilizar para os apontamentos:$CL_DEFAULT"
    read -p "Descrição Padrão: " INPUT_DESCRIPTION
    echo
}

app_install_generate_config()
{
    echo -e $CL_YELLOW"Realizando configuração, por favor aguarde...:$CL_DEFAULT"

    cat "helpers/env.bash.example" \
        | sed "s/{{LOGIN_PMA}}/$INPUT_LOGIN/g" \
        | sed "s/{{PASSWORD_PMA}}/$INPUT_PASSWORD/g" \
        | sed "s/{{COD_PROJECT_DEFAULT}}/$INPUT_COD_PROJECT/g" \
        | sed "s/{{PROJECT_DEFAULT_DESC}}/$PROJECT_DEFAULT_DESC/g" \
        | sed "s/{{COD_ACTIVITY_DEFAULT}}/$INPUT_COD_ACTIVITY/g" \
        | sed "s/{{ACTIVITY_DEFAULT_DESC}}/$ACTIVITY_DEFAULT_DESC/g" \
        | sed "s/{{DESCRIPTION_DEFAULT}}/$INPUT_DESCRIPTION/g" > "helpers/env.bash"

    echo -e $CL_GREN"Configuração realizada com sucesso!"
    echo
}