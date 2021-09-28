// const AWS = require('aws-sdk');
// const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

const { handler } = require('../../../nodejs/employees/postEmployee');

const mockDynamoDbPut = jest.fn().mockImplementation(() => {
    return {
      promise() {
        return Promise.resolve({});
      }
    };
  });
    
  jest.doMock('aws-sdk', () => {
    return {
      DynamoDB: jest.fn(() => ({
        DocumentClient: jest.fn(() => ({
          put: mockDynamoDbPut
        }))
      }))
    };
  });

describe('employeee', () => {
    test('should return success when add a employee ', async () => {
        const mResponse = { body: 200, data: 'mocked data' };
        const mEvent = JSON.stringify({ body: {
                                                data: { 
                                                    id: 1,
                                                    name: 'nome',
                                                    position: 'dev',
                                                    age: '24' 
                                                } ,
                                                tableName: 'Employee'
                                            } 
                                      });
        when(handler).createEmployee
        expect(actualValue).toEqual(mResponse);
        expect(retrieveDataSpy).toBeCalled();
    })
    test('should return fail when add a employee ', async () => {
      const mResponse = { body: 500, data: 'mocked data' };
      const mEvent = JSON.stringify({ body: {
                                              data: { 
                                                  id: 1,
                                                  name: 'nome',
                                                  position: 'dev',
                                                  age: '24' 
                                              } ,
                                              tableName: 'Employee'
                                          } 
                                    });
      const actualValue = await handler(mEvent);
      expect(actualValue).toEqual(mResponse);
      expect(retrieveDataSpy).toBeCalled();
  })
})