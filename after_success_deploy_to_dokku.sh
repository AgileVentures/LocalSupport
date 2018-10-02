#!/bin/bash

# eval "$(ssh-agent -s)"
# chmod 600 .travis/deploy.key
# echo -e "Host $SERVER_IP_ADDRESS\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
# ssh-add .travis/deploy.key
ssh-keyscan agileventures-playground.westeurope.cloudapp.azure.com >> ~/.ssh/known_hosts
git remote add develop dokku@agileventures-playground.westeurope.cloudapp.azure.com:harrowcn-develop
git config --global push.default simple
git push develop develop:master
exit 0
