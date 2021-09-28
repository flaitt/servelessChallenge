module.exports = {
    tables: [
      {
        TableName: `Employees`,
        KeySchema: [{AttributeName: 'Id', KeyType: 'HASH'}],
        AttributeDefinitions: [{AttributeName: 'Id', AttributeType: 'N'}],
        ProvisionedThroughput: {ReadCapacityUnits: 1, WriteCapacityUnits: 1},
      },
      // etc
    ],
  };