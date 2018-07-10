Azure Dokku Deploy
------------------

Assuming you have ssh access set up you can deploy to Azure Dokku as follows

```
$ ssh dokku@agileventures.eastus.cloudapp.azure.com config:set harrowcn-develop DEVISE_SECRET_KEY=1234
$ ssh dokku@agileventures.eastus.cloudapp.azure.com postgres:create harrowcn-develop
$ ssh dokku@agileventures.eastus.cloudapp.azure.com postgres:link harrowcn-develop harrowcn-develop
$ ssh dokku@agileventures.eastus.cloudapp.azure.com run harrowcn-develop rails db:migrate
$ git push azure-develop develop:master
$ ssh dokku@agileventures.eastus.cloudapp.azure.com config:set --no-restart harrowcn-develop DOKKU_LETSENCRYPT_EMAIL=technical@harrowcn.org.uk
$ ssh dokku@agileventures.eastus.cloudapp.azure.com letsencrypt harrowcn-develop
$ ssh dokku@agileventures.eastus.cloudapp.azure.com letsencrypt:auto-renew harrowcn-develop
```
