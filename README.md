# PMA (for monsters)

Para quem vive no terminal e não quer sair para fazer aponamento.

## Configuração

Antes de utilizar você preecher os parâmetros de configuração abaixo no arquivo: `scripts/configs.bash`

- LOGIN=<login_pma>
- PASSWORD=<password_pma>
- PROJECT_DEFAULT=<project_id>
- ACTIVITY_DEFAULT=<activity_id>
- DESCRIPTION_DEFAULT='description default here'

## Apontamento

`./pma.sh new <hr_start> <hr_end> <description :optional> <date :optional>`

#### Examle 1:
Apontamento para data atual e descrição padrão:

`./pma.sh new 08:00 12:00`

#### Examle 2:
Apontamento para data atual e descrição personalizada:

`./pma.sh new 08:00 12:00 'Descrição aqui...'`

#### Examle 3:
Apontamento para data e descrição personalizada:

`./pma.sh new 08:00 12:00 'Descrição aqui...' 29/01/2020`

