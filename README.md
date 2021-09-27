# Serverless Challenge

Utilização do terraform para provisionar uma lambda, um dynamoDB e uma api-gateway que insere, atualiza, consulta e remove dados de um funcionário de uma empresa.

## Environments

No arquivo terraform/variables.tf você deve adicionar sua região de utilização e sua "account id" da AWS.

Deve-se também alterar a região no arquivo lambda/employees.js

## Run the app

Para provisionar os recursos necessários para utilização desse app, utilize o comando no diretório /terraform:

```terraform apply```

## Utilização da api

A api é controlada somente por requisições `HTTP GET` endpoint: `/v1/employees` 

Você pode testar a última versão publica exposta por mim: `https://c8qxhu5l2k.execute-api.us-east-2.amazonaws.com/employees-stage`

Tendo assim, 4 ações, controladas pelo  `action` do `body`, sendo elas:

### 1. Adicionar funcionário
 ```
{ 
    "action": "create",
    "tableName": "Employees",
    "data": {
        "id": 2,
        "age": "24",
        "name": "Fulando De Tal",
        "position": "Developer"
    }
}
 ```

 ### 2. Consultar funcionário (por ID)
 ```
{ 
    "action": "read",
    "tableName": "Employees",
    "data": {
        "id": 2
    }
}
 ```

 ### 3. Atualizar dados do funcionário (por ID)
 ```
{ 
    "action": "update",
    "tableName": "Employees",
    "data": {
        "id": 2,
        "age": "25",
        "name": "Novo nome de Fulando De Tal",
        "position": "Novo cargo de Developer"
    }
}
 ```

### 4. Remover funcionário (por ID)
 ```
{ 
    "action": "remove",
    "tableName": "Employees",
    "data": {
        "id": 2
    }
}
 ```
## Por fim, para retirar os recursos montados na aws, rode o comando:

``` terraform destroy ```
