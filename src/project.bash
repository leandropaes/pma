app_project()
{
    case ${2} in
        "list") logo; app_project_list ;;
        "items") logo; app_project_items ${3} ;;
        "refresh") > $PROJECTS_FILE; logo; app_project_list ;;
        *) menu_project ;;
    esac
}

app_project_list()
{
    if [ ! -s "$PROJECTS_FILE" ] 
    then
        app_project_list_refresh
    fi

    out "
=====================================================================
$CL_YELLOW COD$CL_DEFAULT\t | \t$CL_YELLOW PROJECT$CL_DEFAULT
====================================================================="
    cat $PROJECTS_FILE
}

app_project_list_refresh()
{
    # list projects
    curl -s -b $COOKIE_FILE GET {$URL}/registros \
        | sed -n '/<select id="registro_projeto_id"/,/<\/select/p' \
        | grep -P 'value="\K[^"]+' \
        | sed -e 's/<option value=//g' -e 's/<\/option>//g' -e 's/">/\t | \t /g' -e 's/"/ /g' -e 's/<\/select>//g' \
        > $PROJECTS_FILE
}

app_project_items()
{    
    PROJECT_COD=${1}

    if [ -z "$PROJECT_COD" ] ; then
        logo
        
        echo -e $CL_RED"PMA - ATENÇÃO\n"$CL_DEFAULT
        echo -e 'Por favor, verifique se informou todos os parâmetros corretamente:\n'
        echo -e "Ex: ./$THIS project items <project_cod>\n"
        exit 1
    fi
    
    echo > $CURL_RESPONSE_FILE

    # list items
    curl -s -b $COOKIE_FILE -X 'POST' {$URL}/registros/set_atividade?projeto_id=$PROJECT_COD \
        | sed -n '/<select id="registro_atividade_id"/,/<\/select/p' \
        | grep -P 'value="\K[^"]+' \
        | sed -e 's/<option value=//g' -e 's/<\/option>//g' -e 's/">/\t | \t /g' -e 's/"/ /g' -e 's/<\/select>//g' \
        > $CURL_RESPONSE_FILE

    if [ ! -s "$CURL_RESPONSE_FILE" ] ; then
        echo -e "$CL_YELLOW\nNão há atividades atribuídas para você neste projeto.\nNão será possível efetuar apontamentos. Por favor, contate o gerente do projeto.$CL_DEFAULT"
        echo
        exit 1
    else
        out "
=====================================================================
$CL_YELLOW COD$CL_DEFAULT\t | \t$CL_YELLOW ACTIVITY$CL_DEFAULT
====================================================================="
        cat $CURL_RESPONSE_FILE
    fi
}