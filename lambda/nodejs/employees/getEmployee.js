const AWS = require('aws-sdk');
const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

exports.handler = async (event, context, callback) => {
    event = JSON.parse(event['body'])
    
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
    
};

function consultEmployeeById(tableName, data) {
    const params = {
        TableName: tableName,
        Key: {
            'Id': data.id,
        }
    }
    return ddb.get(params).promise();
}
