login()
{
    if [ -z "$LOGIN" ] || [ -z "$PASSWORD" ] || [ -z "$PROJECT_DEFAULT" ] || [ -z "$ACTIVITY_DEFAULT" ] || [ -z "$DESCRIPTION_DEFAULT" ] ; then
        logo
        
        out "$CL_RED
PMA - ATENÇÃO$CL_DEFAULT

Por favor, informe os campos abaixo no arquivo:$CL_YELLOW scripts/configs.bash$CL_DEFAULT

- LOGIN
- PASSWORD
- PROJECT_DEFAULT
- ACTIVITY_DEFAULT
- DESCRIPTION_DEFAULT"

        exit 1
    fi

    curl -s -c $COOKIE_FILE POST {$URL}/login/login -F "usuario[login]=$LOGIN" -F "usuario[senha]=$PASSWORD" > /dev/null
}

app_project()
{
    case ${2} in
        "list") app_project_list ;;
        "items") app_project_items ${@} ;;
        "refresh") > $PROJECTS_FILE; app_project_list ;;
        *) menu_project ;;
    esac
}

app_project_list()
{
    if [ ! -s "$PROJECTS_FILE" ] 
    then
        app_project_list_refresh
    fi

    logo 

    out "
=====================================================================
$CL_YELLOW COD$CL_DEFAULT\t | \t$CL_YELLOW PROJECT$CL_DEFAULT
====================================================================="
    cat $PROJECTS_FILE

    echo
}

app_project_list_refresh()
{
    login
    
    # list projects
    curl -s -b $COOKIE_FILE GET {$URL}/registros \
        | sed -n '/<select id="registro_projeto_id"/,/<\/select/p' \
        | grep -P 'value="\K[^"]+' \
        | sed -e 's/<option value=//g' -e 's/<\/option>//g' -e 's/">/\t | \t /g' -e 's/"/ /g' -e 's/<\/select>//g' \
        > $PROJECTS_FILE
}

app_project_items()
{
    # login
    PROJECT_COD=${3}

    if [ -z "$PROJECT_COD" ] ; then
        logo
        
        echo -e $CL_RED"PMA - ATENÇÃO\n"$CL_DEFAULT
        echo -e 'Por favor, verifique se informou todos os parâmetros corretamente:\n'
        echo -e "Ex: ./$THIS project items <project_cod>\n"
        exit 1
    fi
    
    echo > $CURL_RESPONSE_FILE

    # list items
    curl -s -b $COOKIE_FILE POST {$URL}/registros/set_atividade?projeto_id=$PROJECT_COD \
        | sed -n '/<select id="registro_atividade_id"/,/<\/select/p' \
        | grep -P 'value="\K[^"]+' \
        | sed -e 's/<option value=//g' -e 's/<\/option>//g' -e 's/">/\t | \t /g' -e 's/"/ /g' -e 's/<\/select>//g' \
        > $CURL_RESPONSE_FILE

    logo 

    if [ ! -s "$CURL_RESPONSE_FILE" ] ; then
        echo -e "$CL_YELLOW\nNão há atividades atribuídas para você neste projeto.\nNão será possível efetuar apontamentos. Por favor, contate o gerente do projeto.$CL_DEFAULT"
        echo
    else
        out "
=====================================================================
$CL_YELLOW COD$CL_DEFAULT\t | \t$CL_YELLOW ACTIVITY$CL_DEFAULT
====================================================================="
        cat $CURL_RESPONSE_FILE
    fi
}

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

    echo -e $CL_YELLOW"Informe a descrição [ENTER para utilizar a padrão]:\n$CL_DEFAULT(Descrição padrão:$CL_GREN $DESCRIPTION_DEFAULT"$CL_DEFAULT")"
    read DESCRIPTION

    if [ -z "$DESCRIPTION" ] ; then
        DESCRIPTION=$DESCRIPTION_DEFAULT
    fi

    echo -e $CL_YELLOW"Informe o código do projeto [ENTER para utilizar a padrão]:\n$CL_DEFAULT(Projeto padrão:$CL_GREN $PROJECT_DEFAULT"$CL_DEFAULT")"
    read PROJECT

    if [ -z "$PROJECT" ] ; then
        PROJECT=$PROJECT_DEFAULT
    fi

    echo -e $CL_YELLOW"Informe o código da atividade do projeto [ENTER para utilizar a padrão]:\n$CL_DEFAULT(Atividade padrão:$CL_GREN $ACTIVITY_DEFAULT"$CL_DEFAULT")"
    read ACTIVITY

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
        echo -e $CL_GREN"Apontamento realizado com sucesso!\n"$CL_DEFAULT
    else
        echo -e $CL_YELLOW"$MSG_ERROR\n"$CL_DEFAULT
    fi
}