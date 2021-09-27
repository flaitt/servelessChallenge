const AWS = require('aws-sdk');
const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

exports.handler = async (event, context, callback) => {
    event = JSON.parse(event['body'])
    
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
