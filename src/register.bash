app_new()
{
    HR_START=${2}
    HR_END=${3}
    DATE=${4-$(date +%d/%m/%Y)}

    if [ -z "$HR_END" ] ; then
        logo
        
        echo -e $CL_RED"PMA - ATENÇÃO\n"$CL_DEFAULT
        echo -e 'Por favor, verifique se informou todos os parâmetros corretamente:\n'
        echo -e "Ex: ./$THIS new 08:00 12:00 <date :optional>\n"
        exit 1
    fi

    # Description input
    echo -e $CL_YELLOW"Informe a descrição [ENTER para utilizar a padrão]:\n$CL_DEFAULT(Descrição padrão:$CL_GREN $DESCRIPTION_DEFAULT"$CL_DEFAULT")"
    read DESCRIPTION
    echo

    if [ -z "$DESCRIPTION" ] ; then
        DESCRIPTION=$DESCRIPTION_DEFAULT
    fi

    # Project input
    echo -e $CL_YELLOW"Informe o código do projeto [ENTER para utilizar a padrão]:\n$CL_DEFAULT(Projeto padrão:$CL_GREN $PROJECT_DEFAULT"$CL_DEFAULT")"
    app_project_list
    echo
    read -p "Código do Projeto: " PROJECT
    echo

    if [ -z "$PROJECT" ] ; then
        PROJECT=$PROJECT_DEFAULT
    fi

    # Activity input
    if [ $PROJECT != $PROJECT_DEFAULT ]; then
        echo -e $CL_YELLOW"Informe o código da atividade do projeto:$CL_DEFAULT"
    else
        echo -e $CL_YELLOW"Informe o código da atividade do projeto [ENTER para utilizar a padrão]:\n$CL_DEFAULT(Atividade padrão:$CL_GREN $ACTIVITY_DEFAULT"$CL_DEFAULT")"
    fi

    app_project_items $PROJECT
    echo
    read -p "Código da Atividade: " ACTIVITY
    echo

    if [ -z "$ACTIVITY" ] ; then
        ACTIVITY=$ACTIVITY_DEFAULT
    fi

    login

    echo > $CURL_RESPONSE_FILE

    # register new pma
    curl -s -b $COOKIE_FILE POST {$URL}/registros/create \
        -F "registro[true_date]=$DATE" \
        -F "registro[inicio]=$HR_START" \
        -F "registro[fim]=$HR_END" \
        -F "registro[descricao]=$DESCRIPTION" \
        -F "registro[projeto_id]=$PROJECT" \
        -F "registro[atividade_id]=$ACTIVITY" \
        -F "commit=Salvar" > $CURL_RESPONSE_FILE

    MSG_ERROR=$(cat $CURL_RESPONSE_FILE | sed -n 's:.*id="msgNotice">\(.*\)</p>.*:\1:p')

    if [ -z "$MSG_ERROR" ] ; then
        echo $MSG_ERROR
        echo -e $CL_GREN"Apontamento realizado com sucesso!\n"$CL_DEFAULT
    else
        echo -e $CL_YELLOW"$MSG_ERROR\n"$CL_DEFAULT
    fi
}