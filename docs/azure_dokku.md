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

N.B. creating a random key on linux:

```
$ date +%s | sha256sum | base64 | head -c 32 ; echo
```

on OSX:
```
$ date | md5 | head -c32; echo
```

5. create and link database

```
ssh avp-dokku postgres:create harrowcn-temp
ssh avp-dokku postgres:link harrowcn-temp harrowcn-temp
```

N.B. you can check the status of all the database:

```
ssh avp-dokku postgres:list
```

6. push the code up

```
$ git push azure-develop develop:master
```

7. set the domain

```
ssh avp-dokku domains:add harrowcn-temp temp.harrowcn.org.uk
```

8. set up the https

```
$ ssh avp-dokku config:set --no-restart harrowcn-temp DOKKU_LETSENCRYPT_EMAIL=technical@harrowcn.org.uk
$ ssh avp-dokku letsencrypt harrowcn-temp
$ ssh avp-dokku letsencrypt:cron-job add (this adds it for every app on the box)
```

9. import data into the database

```
$ ssh avp-dokku postgres:import harrowcn-temp < latest.dump
```

N.B. to grab data from heroku

https://devcenter.heroku.com/articles/heroku-postgres-import-export

```
$ heroku pg:backups:capture -r temp
$ heroku pg:backups:download -r temp
```

N.B. to export data from dokku

```
$ ssh avp-dokku postgres:export harrowcn-temp > latest.dump # not checked for accuracy
```


10. set some ENV vars

```
$ ssh avp-dokku config:set harrowcn-temp GMAP_API_KEY=1234
```

N.B. [TODO some notes on how to get a GMAP_API_KEY?]

...

N.B. if you need to run the migrations manually (should auto-run as part of post-deploy hook)

```
ssh avp-dokku run harrowcn-temp rails db:migrate
```


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
$ ssh dokku@agileventures.eastus.cloudapp.azure.com letsencrypt:cron-job --add
```
