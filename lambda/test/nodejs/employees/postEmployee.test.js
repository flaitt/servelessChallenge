const AWS = require('aws-sdk');
const ddb = new AWS.DynamoDB.DocumentClient({region: 'us-east-2'});

const { promisify } =require('util');
const lambda = require('../../../nodejs/employees/postEmployee')
const handler = promisify(lambda);

describe(`Service aws-node-singned-uploads`, () => {
    test(`Require environment variables`, () => {
      const event = {};
      const context = {};
  
      const result = handler(event, context);
      result
        .then(data => {
          expect(data).toBeFalsy();
        })
        .catch(e => {
          expect(e).toBe(
            `Missing required environment variables: BUCKET, REGION`
          );
        });
    });
  });


