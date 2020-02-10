login()
{
    if [ -z "$LOGIN" ] || [ -z "$PASSWORD" ] || [ -z "$PROJECT_DEFAULT" ] || [ -z "$ACTIVITY_DEFAULT" ] || [ -z "$DESCRIPTION_DEFAULT" ] ; then
        logo
        
        out "$CL_RED
PMA - ATENÇÃO$CL_DEFAULT

Por favor, informe os campos abaixo no arquivo:$CL_YELLOW helpers/configs.bash$CL_DEFAULT

- LOGIN
- PASSWORD
- PROJECT_DEFAULT
- ACTIVITY_DEFAULT
- DESCRIPTION_DEFAULT"

        exit 1
    fi

    curl -s -c $COOKIE_FILE POST {$URL}/login/login -F "usuario[login]=$LOGIN" -F "usuario[senha]=$PASSWORD" > /dev/null
}