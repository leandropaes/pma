menu()
{
    logo

    out "
<33>Usage:<0>
    ./$THIS [command] [options]

<33>Commands:
    <32;1>new<0>                 Novo apontamento
    <32;1>project<0>             Lista de projetos do seu usuário
    "
}

menu_project()
{
    logo

    out "
<33>Usage:<0>
    ./$THIS project [command]

<33>Commands:
    <32;1>list<0>                           Lista projetos do seu usuário
    <32;1>items <33;1><project_cod><0>       Lista atividades de um projeto
    <32;1>refresh<0>                        Atualiza lista de projetos do seu usuário
    "
}