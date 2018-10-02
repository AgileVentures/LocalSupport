#!/bin/bash
openssl aes-256-cbc -K $encrypted_a6fc752c6b5a_key -iv $encrypted_a6fc752c6b5a_iv -in deploy_key.enc -out ./deploy_key -d
eval "$(ssh-agent -s)"
chmod 600 ./deploy_key
echo -e "Host $SERVER_IP_ADDRESS\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
ssh-add ./deploy_key
# test ssh connection for: https://github.com/dwyl/learn-travis/issues/42
exit 0
