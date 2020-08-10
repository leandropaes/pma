app_register()
{
    login
    
    app_register_list ${2}
}

app_register_list_header()
{
    logo
    
    out "
========================================================================
$CL_YELLOW DATA$CL_DEFAULT       | $CL_YELLOW INÍCIO$CL_DEFAULT | $CL_YELLOW FIM$CL_DEFAULT    | $CL_YELLOW DESCRIÇÃO$CL_DEFAULT
========================================================================"
}

app_register_list()
{
    START=${1}

    if [ -z "$START" ] ; then
        logo
        
        echo -e $CL_RED"PMA - ATENÇÃO\n"$CL_DEFAULT
        echo -e 'Por favor, verifique se informou todos os parâmetros corretamente:\n'
        echo -e "Ex: ./$THIS list <date_start>\n"
        exit 1
    fi

    # list registers
    echo -en "$(curl -s -b $COOKIE_FILE {$URL}/registros.json?inicio=$START)" > $REGISTERS_FILE

    app_register_list_header

    pr -mtJ \
    <(grep -Po '"true_date": *\K"[^"]*"' $REGISTERS_FILE) \
    <(grep -Po '"inicio": *\K"[^"]*"' $REGISTERS_FILE | cut -dT -f2 | cut -d: -f1,2) \
    <(grep -Po '"fim": *\K"[^"]*"' $REGISTERS_FILE | cut -dT -f2 | cut -d: -f1,2) \
    <(grep -Po '"descricao": *\K"[^"]*"' $REGISTERS_FILE) \
    | sed 's/",//g' | sed 's/"//g' | sed 's/\t/|/g' | sed 's/|/  |  /g'
}