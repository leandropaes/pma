app_clear()
{
    echo -e $CL_YELLOW"Excluindo arquivos de cache...\n"
    rm -rf cache/*
    
    echo -e $CL_GREN"Arquivos excluídos com sucesso!"
    echo
}