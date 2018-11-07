#!/bin/bash
openssl aes-256-cbc -K $encrypted_a6fc752c6b5a_key -iv $encrypted_a6fc752c6b5a_iv -in deploy_key.enc -out ./deploy_key -d
eval "$(ssh-agent -s)"
chmod 600 ./deploy_key
ssh-add ./deploy_key
ssh-keyscan agileventures-playground.westeurope.cloudapp.azure.com >> ~/.ssh/known_hosts
git remote add develop dokku@agileventures-playground.westeurope.cloudapp.azure.com:harrowcn-develop
git config --global push.default simple
git push develop develop:master -f