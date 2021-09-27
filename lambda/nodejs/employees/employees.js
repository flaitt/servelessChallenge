const AWS = require('aws-sdk');
const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

exports.handler = async (event, context, callback) => {
    event = JSON.parse(event['body'])
    var action = event.action;
    
    switch (action) {
        case 'create':
            await createEmployee(event.tableName, event.data).then(() => {
                callback(null, {
                    statusCode: 201,
                    body: '',
                    headers: {
                        'Access-Control-Allow-Origin': '*'
                    }
                })
            }).catch ((err) => {
                console.log(err);
            });
            break;
        case 'read':
            await consultEmployeeById(event.tableName, event.data).then((data) => {
                callback(null, {
                    statusCode: 200,
                    body: JSON.stringify(data.Item),
                    headers: {
                        'Access-Control-Allow-Origin': '*',
                        'Content-Type':'application/json',
                    }
                })
            }).catch ((err) => {
                console.log(err);
            });
            break;
        case 'update':
            await updateEmployeeById(event.tableName, event.data).then((data) => {
                callback(null, {
                    statusCode: 200,
                    body: JSON.stringify(data.Attributes),
                    headers: {
                        'Access-Control-Allow-Origin': '*',
                        'Content-Type':'application/json',
                    }
                })
            }).catch ((err) => {
                console.log(err);
            });
            break;
        case 'remove':
            await deleteEmployeeById(event.tableName, event.data).then((data) => {
                callback(null, {
                    statusCode: 200,
                    body: 'Deleted',
                    headers: {
                        'Access-Control-Allow-Origin': '*'
                    }
                })
            }).catch ((err) => {
                console.log(err);
            });
            break;
        default:
            callback(null, {
                statusCode: 400,
                body: 'error',
                headers: {
                    'Access-Control-Allow-Origin': '*'
                }
            })
    }
};

function createEmployee(tableName, data) {
    const params = {
        TableName: tableName,
        Item: {
            'Id': data.id,
            'Age': data.age,
            'Name': data.name,
            'Position': data.position
        }
    }
    return ddb.put(params).promise();
}

function consultEmployeeById(tableName, data) {
    const params = {
        TableName: tableName,
        Key: {
            'Id': data.id,
        }
    }
    return ddb.get(params).promise();
}

function deleteEmployeeById(tableName, data) {
    const params = {
        TableName: tableName,
        Key: {
            'Id': data.id,
        }
    }
    return ddb.delete(params).promise();
}

function updateEmployeeById(tableName, data) {
    const params = {
        TableName: tableName,
        Key: {
            "Id": data.id
        },
        UpdateExpression: "set #Name = :n, #Age = :a, #Position = :p",
        ExpressionAttributeValues: {
            ":n": data.name,
            ":a": data.age,
            ":p": data.position
        },
        ExpressionAttributeNames: {
            "#Name": "Name",
            "#Age": "Age",
            "#Position": "Position"
        },
        ReturnValues: "UPDATED_NEW"
    }
    return ddb.update(params).promise();
}