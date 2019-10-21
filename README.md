
## Criação de chave publica e privada SSH

Para a geração da chave publica e privada, foi rodado o comando a seguir numa maquina windows:

### `ssh-keygen -t rsa`

O mesmo gerou uma chave SHA256 RSA 2048


## GitClone SSH

Para acesso ao repositorio de forma SSH é necessário antes de tudo fazer o download(.Zip) do projeto, extrair, acessar a pasta do projeto e executar os seguintes comandos:

### `cp id_rsa /home/[usuario]/.ssh/id_rsa`

### `cd /home/[usuario]/.ssh`

### `chmod 400 id_rsa`


Acessar a local onde deseja instalar e executar o comando a seguir:

### `git clone git@github.com:brunandrade/PI_HPC.git`
