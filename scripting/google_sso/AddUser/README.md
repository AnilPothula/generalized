## Google API configuration

#### Prerequisites

- You need a Google Account to access the Google API Console, request an API key, and register your application.
- Create a project in the [Google Developers Console](https://console.developers.google.com) and obtain [authorization credentials](https://console.developers.google.com/apis/credentials) so your application can submit API requests.
- Create a Schema

#### Creating a Schema

To create the JSON schema, you use the [Schemas: Insert](https://developers.google.com/admin-sdk/directory/v1/reference/schemas/insert#try-it) request from the Google Directory API that will take you to a Google developer webpage, allowing you to enter the required request fields and then click the AUTHORIZE AND EXECUTE button to have the https POST request to the Directory API automatically generated for you. This will require authentication.

On the **Schemas: Insert** page, enter the customer ID in the **customerId** field, which you noted when downloading the metadata file before to create the terraform stacks. Then click inside the editing box for the request body, and in the right corner from the drop-down list, select Freeform Editor and paste the following text in the box.

```
{
  "fields": [
    {
      "fieldName": "role",
      "fieldType": "STRING",
      "readAccessType": "ADMINS_AND_SELF",
      "multiValued": true,
      "displayName": "role"
    }
  ],
  "schemaName": "SSO",
  "displayName": "SSO"
}
```
​
In this case, `SSO` is the name of you Schema, keep this in mind when you execute the adduser.py python script.

#### Obtain an API_KEY
For authentication and quota purposes, you will need to use the **Google Street View Publish API** with credentials generated from your Developers Console.
​
- Navigate to the [Credentials](https://console.developers.google.com/apis/credentials) page in your Developers Console.
- If you already have an API key, you can use the value from it. Otherwise, create a new one by selecting API key from the **New credentials** menu.
​

####  Obtain an ACCESS_TOKEN
In order to generate an access token, we need to crear a client ID and a client secret first.
​
- To obtain the client ID and client secret, go to the [Credentials](https://console.developers.google.com/apis/credentials) page in your Developers Console. If you do not have an existing OAuth 2.0 client, create a new OAuth 2.0 client ID by selecting OAuth client ID under the Create credentials menu and use the following configuration:
​
 - Application type:	Web application
 - Name:	(any value)
 - Authorized: JavaScript origins	(empty)
 - Authorized: redirect URIs	https://developers.google.com/oauthplayground
​
​
- Navigate to the [Google Developers OAuth 2.0 Playground](https://developers.google.com/oauthplayground/).
​
- Click the settings menu (gear icon on the top right), check **Use your own OAuth credentials** and input your Client ID and Client secret in the corresponding fields, and then click Close.
​
- Under **Step 1: Select & authorize APIs**, input the API scope `https://www.googleapis.com/auth/admin.directory.user` in the Input your own scopes field, then click Authorize APIs. A new page will open to confirm that you want to authorize the API. This scope is needed to allow the API to manage our google users.
​
- Click **Exchange authorization code for tokens**. This will populate the **Access token** field, which will contain your access token to be used in the next step. The access token expires in 60 minutes. You can select the option to auto-refresh the token before it expires, which will create a new token.

#### Run the script

Once you have populated the `user.yaml` file then you are ready to run the script. Follow the next instruction as an example, if you require help type `--help` as option.

```
python3 adduser.py adduser --api_key $API_KEY --access_token $ACCESS_TOKEN
```

If this is the first time that you run an API call in a new project you will be prompted with the next message:

```
{
 "error": {
  "errors": [
   {
    "domain": "usageLimits",
    "reason": "accessNotConfigured",
    "message": "Project 644747961313 is not found and cannot be used for API calls. If it is recently created, enable Admin Directory API by visiting https://console.developers.google.com/apis/api/admin.googleapis.com/overview?project=644747961313 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.",
    "extendedHelp": "https://console.developers.google.com/apis/api/admin.googleapis.com/overview?project=644747961313"
   }
  ],
  "code": 403,
  "message": "Project 644747961313 is not found and cannot be used for API calls. If it is recently created, enable Admin Directory API by visiting https://console.developers.google.com/apis/api/admin.googleapis.com/overview?project=644747961313 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry."
 }
}
```

Just hit the link and enable the access.

#### Creating a SAML APP

This documentation still in progress, for now follow the steps 5 and 6 of the following link:

https://aws.amazon.com/es/blogs/security/how-to-set-up-federated-single-sign-on-to-aws-using-google-apps/
