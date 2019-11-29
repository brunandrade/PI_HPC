## Funcionalidades

O presente repositório foi utilizado como método avaliativo do Projeto Integrado 2 da turma de Engenharia de Computação do Centro Universitário SENAI CIMATEC pelos componentes:

[Bruna Andrade](https://www.github.com/brunandrade) 

[Gabriel Luiz](https://www.github.com/gabrielluiz97) 

[Leonardo Sena](https://www.github.com/leosena21)

[Lucas Cassimiro](https://www.github.com/ccassimiro)

[Tarcio Carvalho](https://www.github.com/Tarcioc2)


O script criado em Shell traz utilizando Dialog informações sobre CPU, Memória, HD e Barramento. Além de configurar proxy(Squid) e Firewall(Iptables).

Caso o usuário deseje realizar o bloqueio de mais algum site pelo Proxy, é necessário alteração no arquivo `bad-sites.acl` .



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
