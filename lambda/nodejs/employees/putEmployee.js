const AWS = require('aws-sdk');
const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

exports.handler = async (event, context, callback) => {
    event = JSON.parse(event['body'])

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
};

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