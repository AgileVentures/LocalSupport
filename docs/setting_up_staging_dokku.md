# Setting up Staging server on Dokku

### Make sure you have the permissions to ssh as dokku on the azure box you want to create the server on, then add this to your ~/.ssh/config

```
Host avp-dokku
  HostName agileventures-playground.westeurope.cloudapp.azure.com
  User dokku
```

### Create app on Dokku

```
ssh avp-dokku apps:create harrowcn-staging
```

### Generate secret key for Devise on Linux
```
date +%s | sha256sum | base64 | head -c 32 ; echo
```

### Configure Devise Secret Key and Letsencrypt email

```
ssh avp-dokku config:set --no-restart harrowcn-staging DEVISE_SECRET_KEY=<SECRET_KEY> DOKKU_LETSENCRYPT_EMAIL=<email>
```
### Create and link postgres database

```
ssh avp-dokku postgres:create harrowcn-staging
ssh avp-dokku postgres:link harrowcn-staging harrowcn-staging
```
### With upstream remote set as 

```
$ git remote -v

upstream	git@github.com:AgileVentures/LocalSupport.git (fetch)
upstream	git@github.com:AgileVentures/LocalSupport.git (push)
```

### Switch to the staging branch

```
git checkout upstream/staging
```

### Create staging branch locally 

```
git checkout -b staging
```

### Add as remote

```
git remote add azure-playground-staging avp-dokku:harrowcn-staging
```
### Run migrations

```
ssh avp-dokku run harrowcn-staging rails db:migrate 
```
### Set domain 

```
ssh avp-dokku domains:set harrowcn-staging staging.harrowcn.org.uk
```

### Push staging to the server

```
git push azure-playground-staging staging:master
```

### Add ssl certs for https access and enable auto renew

```
ssh avp-dokku letsencrypt harrowcn-staging
ssh avp-dokku letsencrypt:cron-job --add (this adds it for every app on the box)
```
_You can also enter a shell session in dokku to run these commands without ssh avp-dokku like_

```
ssh -t avp-dokku shell
```
### If you want to enter an apps container, run

```
enter <container>
```



