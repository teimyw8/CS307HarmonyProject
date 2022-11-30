const functions = require("firebase-functions");
const admin = require("firebase-admin");
//  const runtimeOpts = {
//  timeoutSeconds: 120,
//  memory: "128MB",
//  };
admin.initializeApp();
const fcm = admin.messaging();
//  const database = admin.firestore();

exports.sendNewMessageNotification = functions.https.onCall(
    async (data, context) => {
      const title = data.title;
      const body = data.body;
      const token = data.token;
      console.log("token is: " + token);
      console.log("body is: " + body);
      try {
        const payload = {
          notification: {
            title: title,
            body: body,
          },
          data: {
            body: body,
          },
        };
        fcm.sendToDevice(token, payload)
            .then(function(response) {
              console.log("Successfully sent message:", response);
              console.log(response.results[0].error);
            })
            .catch(function(error) {
              console.log("Error sending message:", error);
            });
      } catch (error) {
        console.log(error);
      }
    });


exports.sendFriendRequestNotification = functions.https.onCall(
    async (data, context) => {
      const title = data.title;
      const body = data.body;
      const token = data.token;
      console.log("token is: " + token);
      console.log("body is: " + body);
      try {
        const payload = {
          notification: {
            title: title,
            body: body,
          },
        };
        fcm.sendToDevice(token, payload)
            .then(function(response) {
              console.log("Successfully sent message:", response);
              console.log(response.results[0].error);
            })
            .catch(function(error) {
              console.log("Error sending message:", error);
            });
      } catch (error) {
        console.log(error);
      }
    });
