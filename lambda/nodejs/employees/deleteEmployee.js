const AWS = require('aws-sdk');
const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

exports.handler = async (event, context, callback) => {
    event = JSON.parse(event['body'])

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
};

function deleteEmployeeById(tableName, data) {
    const params = {
        TableName: tableName,
        Key: {
            'Id': data.id,
        }
    }
    return ddb.delete(params).promise();
}
