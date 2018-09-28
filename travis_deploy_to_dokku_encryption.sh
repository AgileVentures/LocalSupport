#!/bin/bash
openssl aes-256-cbc -K $encrypted_eee247762962_key -iv $encrypted_eee247762962_iv -in .travis/deploy.key.enc -out .travis/deploy.key -d
exit 0
