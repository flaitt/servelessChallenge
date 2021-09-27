const employees = require('../employees');

const event = {
    action: "create",
    tableName: "Employees",
    data: {
        id: 1,
        age: 25,
        name: "Joao",
        position: "Dev"
    }
}
const mockAWS = require('aws-sdk');
var mockedddb = mock(new mockAWS.DynamoDB.DocumentClient({region: 'us-east-2'}))

it('Should insert employee', () => {
    when(mockedddb).put(Any).thenReturn("ok")
    expect(employees(event)).toReturn("ok")
});