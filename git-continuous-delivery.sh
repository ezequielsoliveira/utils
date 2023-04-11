#!/bin/sh

# ANTES DE EXECUTAR
# Esse shell script realiza o processo de entrega contínua, em que busca os arquivos do repositório remoto e os coloca no servidor de produção.
# Alterar a variável `LOCAL_REPOSITORY_PATH` com caminho do repositório local após ter realizado `git clone` ou `pull` do repositório remoto
# Verifique possíveis problemas que podem impedir o script de executar corretamente, como definir a reconciliação de branches divergentes como com `git config pull.rebase false` e permissões de arquivos criados pelo sistema operacional após fazer o primeiro pull
# Definir o script com permissão de execução (chmod u+x git-ci.sh) e executar o script (./git-ci.sh)

# INFORMAÇÕES SOBRE ESSE SCRIPT
# Esse é um script shell que verifica o status do repositório GIT local em relação ao repositório GIT remoto. Com isso é posível fazer `git pull` do repositório remoto para local quando houver novas alterações no repositório remoto.

# Variável para definir caminho base sobre o script vai executar.
# O caminho do repositório git local.
LOCAL_REPOSITORY_PATH="{GIT_LOCAL_REPOSITORY_PATH}"

cd $LOCAL_REPOSITORY_PATH

# O comando `git fetch` é usado para buscar as atualizações mais recentes de um repositório remoto e atualizar as referências locais sem mesclar automaticamente as mudanças com o código existente.
git fetch

# O comando `git remote update` faz o mesmo que o comando `git fetch`, mas também atualiza informações adicionais sobre o repositório remoto, como os nomes das ramificações e tags remotas. Ele é útil para atualizar as informações do repositório remoto que podem ter mudado, como quando uma nova ramificação foi criada no repositório remoto.
#git remote update

# O `@{u}` é uma abreviação para "upstream", que é a ramificação remota padrão associada à ramificação local em um repositório GIT.
CURRENT_BRANCH="@{u}"

# A sintaxe `$(comando)` é usada no shell para executar um comando e retornar o resultado de sua saída. O comando `git rev-parse` é usado para obter informações sobre um objeto de commit, como seu hash SHA-1. O símbolo @ é usado como um atalho para a referência atual, ou seja, a ramificação em que estamos atualmente.
# Nesse caso retornará o hash SHA-1 do commit mais recente na ramificação atual.
LOCAL_HASH=$(git rev-parse @)

# Nesse caso retornará o hash SHA-1 do commit mais recente na ramificação remota.
REMOTE_HASH=$(git rev-parse "$CURRENT_BRANCH")

# O comando `git merge-base` retornará o hash SHA-1 do commit base mais recente entre as duas ramificações, que é o ponto em que as duas ramificações divergiram.
MOST_RECENT_HASH=$(git merge-base @ "$CURRENT_BRANCH")

if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then # Verifica se o hash do commit mais recente na ramificação local for igual ao hash do commit mais recente na ramificação remota, isso significa que o repositório local está atualizado com o remoto.
    echo "O repositório local está atualizado com o remoto"
elif [ "$LOCAL_HASH" = "$MOST_RECENT_HASH" ]; then # Se o hash do commit mais recente na ramificação local for igual ao hash do commit base mais recente entre as duas ramificações, isso significa que o repositório local precisa ser atualizado.
    echo "O repositório local precisa ser atualizado"
    git pull # Executa o comando git pull para buscar as alterações mais recentes do repositório remoto e mesclá-las com o código existente no repositório local.
elif [ "$REMOTE_HASH" = "$MOST_RECENT_HASH" ]; then # Se hash do commit mais recente no branch remoto é igual ao hash do commit base mais recente entre o branch local e o remoto. Isso indica que o branch remoto está atualizado em relação ao branch local.
    echo "O repositório remoto precisa ser atualizado"
    #git push # Executa o comando `git push` para enviar as alterações do repositório local para o repositório remoto.
else # Se nenhuma das condições acima for atendida, isso significa que o repositório local e remoto divergiram.
    echo "O repositório local e remoto divergiram"
fi
