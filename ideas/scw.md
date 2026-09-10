# scw — cliente HTTP em shell

Ideia parada num repositório só para segurar este arquivo. É especificação, não
código: nada foi escrito.

O último item é o que dá trabalho, e é o mesmo obstáculo do `ideas/ffm.md` —
manter o wrapper vivo entre uma requisição e a próxima, em vez de reexecutar do
zero a cada chamada.

Requisitos como estavam escritos:

- coleções usando pastas
- salvar requisições com um nome/alias e um template incluindo variáveis
- salvar o resultado em uma pasta de resultados com txts correspondentes às requisições
- editar as requisições usando o editor de texto padrão antes de serem enviadas
- pipe para o jq
- fzf para navegar nas coleções e nos aliases com preview dos items da coleção/conteúdo dos itens (em um curl simplificado ?)
- atalho para repetir a requisição em vez de reenviar
- comando para importação
- comando para exportação (usando os últimos valores setados) - caso default com quais valores ?
- edição/clonagem de aliases/requisições
- manter o wrapper funcionando numa única execução (como o LF)

https://github.com/danielgtaylor/restish
