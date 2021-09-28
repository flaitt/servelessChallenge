# Serverless Challenge

Utilização do terraform para provisionar uma lambda function, um dynamoDB e uma api-gateway que insere, atualiza, consulta e remove dados de funcionários de uma empresa.

## CI-CD 
A cada push, é disparado uma GitHub Actions que aplica o comando "terraform apply" automáticamente. 

## Environments

No arquivo terraform/variables.tf você deve adicionar sua região de utilização e sua "account id" da AWS.

Deve-se também alterar a região no arquivo lambda/employees.js

## Run the tests

Para rodar os testes unitários, vocẽ deve ir para o diretório /lambda e rodar o comando 

``` npm run test ```

## Run the app

Para provisionar os recursos necessários para utilização desse app, utilize o comando no diretório /terraform:

```terraform apply```

## Utilização da api

A api é acessível por requisições `HTTP GET, POST, PUT e DELETE` pelo endpoint: `/v1/employees` 

Você pode testar a última versão publica exposta por mim: `https://5ukiokqvbi.execute-api.us-east-2.amazonaws.com/employees-stage`

Tendo assim, 4 ações, controladas pelo  s verbos HTTP e informações no `body`, sendo elas:

### 1. POST - Adicionar funcionário
 ```
{
    "tableName": "Employees",
    "data": {
        "id": 2,
        "age": "24",
        "name": "Fulando De Tal",
        "position": "Developer"
    }
}
 ```

 ### 2. GET - Consultar funcionário (por ID)
 ```
{ 
    "tableName": "Employees",
    "data": {
        "id": 2
    }
}
 ```

 ### 3. PUT - Atualizar dados do funcionário (por ID)
 ```
{
    "tableName": "Employees",
    "data": {
        "id": 2,
        "age": "25",
        "name": "Novo nome de Fulando De Tal",
        "position": "Novo cargo de Developer"
    }
}
 ```

### 4. DELETE - Remover funcionário (por ID)
 ```
{
    "tableName": "Employees",
    "data": {
        "id": 2
    }
}
 ```
## Por fim, para retirar os recursos montados na aws, rode o comando:

``` terraform destroy ```
