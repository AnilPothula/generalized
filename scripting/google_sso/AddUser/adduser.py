import yaml
import json
import requests
import certifi
import click
import urllib3

@click.group()
def cli():
    """Cli to manage parameters for your environments stored on parameter store."""
    pass

def get_url(document, key):
    value = []
    users = document["users"]
    basic_url = "https://www.googleapis.com/admin/directory/v1/users/"
    for user in users:
        user = user.replace("@", "%40")
        value.append(basic_url + user + "?key=" + key)
    return value

def get_header(token):
    basic_header = "Authorization: Bearer "
    value = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + token
    }
    return value

def get_data(document,aws_idp):
    value = []
    users = document["users"]
    for user in users:
        idp_alias = (users[user])
        data = json.loads('{"customSchemas": {"SSO": {"role": []}}}')
        for idp in idp_alias:
            role_alias = (idp_alias[idp]['roles'])
            a = document["idp"]
            aws_idp = a[idp]
            alias = 0
            for role in role_alias:
                segment = json.loads('{"value": "","customType": ""}')
                r = document["roles"]
                segment['value'] = r[role] + "," + aws_idp
                segment['customType'] = role_alias[alias]
                alias += 1
                data['customSchemas']['SSO']['role'].append(segment)
        value.append(data)
    return value

@cli.command()
@click.option('--api_key','-k', help= "The API_KEY generated from https://console.developers.google.com/apis/credentials",default="")
@click.option('--access_token','-t', help= "The ACCESS_TOKEN generated from https://developers.google.com/oauthplayground/",default="")
@click.option('--file','-f', help= "YAML file with users declaration",default="users.yaml")
@click.option('--aws_idp','-i', help= "AWS IDP ARN",default="arn:aws:iam::048502202118:saml-provider/google-idp")
def adduser (api_key,access_token,file,aws_idp):
    urllib3.disable_warnings()
    with open(file, 'r') as f:
        doc = yaml.load(f,yaml.FullLoader)
    data = get_data(doc,aws_idp)
    urls = get_url(doc,api_key)
    header = get_header(access_token)
    i = 0
    for url in urls:
        http = requests.patch(urls[i], json.dumps(data[i]), headers=header, verify=False)
        print (http.text)
        print ("User Added")
        i += 1

if __name__ == '__main__':
    cli()
