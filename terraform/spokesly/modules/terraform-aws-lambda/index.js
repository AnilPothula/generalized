var AWS = require('aws-sdk');
var opsworks = new AWS.OpsWorks();

exports.handler = function(event, context) {
    console.log(event);
    //Log the updated references from the event

    StackId = process.env.STACK_ID;

    opsworks.createDeployment({ Command: { Name: 'update_custom_cookbooks' }, StackId: StackId }, function(err, data) {
        if (err) {
            console.log(err, err.stack); // an error occurred
        } else {
            console.log("successful");
            console.log(data);
        } // successful response
    });

};