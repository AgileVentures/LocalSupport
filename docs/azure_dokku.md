Azure Dokku Deploy
------------------

Assuming you have ssh access set up you can deploy to Azure Dokku as follows

1. add the following to your `~/.ssh/config` file

```
Host avp-dokku
HostName agileventures-playground.westeurope.cloudapp.azure.com
User dokku
```

2. create an appropriately named app

```
ssh avp-dokku apps:create harrowcn-temp
```

3. add a remote for the git repo

```
git remote add temp dokku@agileventures.eastus.cloudapp.azure.com:harrowcn-temp
```

4. set a devise secret key

```
$ ssh avp-dokku config:set harrowcn-production DEVISE_SECRET_KEY=1234
```

5. create and link database

```
ssh avp-dokku postgres:create harrowcn-temp
ssh avp-dokku postgres:link harrowcn-temp harrowcn-temp
```

6. run the migrations

```
ssh avp-dokku run harrowcn-temp rails db:migrate
```

7. push the code up

```
$ git push azure-develop develop:master
```

8. set the domain

```
ssh avp-dokku domains:add harrowcn-temp temp.harrowcn.org.uk
```

9. set up the https

```
$ ssh avp-dokku config:set --no-restart harrowcn-temp DOKKU_LETSENCRYPT_EMAIL=technical@harrowcn.org.uk
$ ssh avp-dokku letsencrypt harrowcn-temp
$ ssh avp-dokku letsencrypt:auto-renew harrowcn-temp
```


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
