Azure Dokku Deploy
------------------

Assuming you have ssh access set up you can deploy to Azure Dokku as follows

1. add the following to your `~/.ssh/config` file

```
Host av-dokku
HostName agileventures.eastus.cloudapp.azure.com
User dokku
```

2. create an appropriately named app

```
ssh av-dokku apps:create harrowcn-temp
```

3. add a remote for the git repo

```
git remote add temp dokku@agileventures.eastus.cloudapp.azure.com:harrowcn-temp
```

4. set a devise secret key

```
$ ssh av-dokku config:set harrowcn-production DEVISE_SECRET_KEY=1234
```

5. create and link database

```
ssh av-dokku postgres:create harrowcn-temp
ssh av-dokku postgres:link harrowcn-temp harrowcn-temp
```


x. set up the https


x. import data into the database

x. set some en


Old Notes
---------

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
