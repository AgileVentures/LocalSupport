# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
LocalSupport::Application.config.secret_token = ENV['MYAPP_SECRET_TOKEN'] || '98f7bafde9e9f5cab69c8e3f25a0f70bf8f97f69594f87fa3caa42e58aa0b1508f1c2efac3123a6975386fc8b9c742df9a844b0024eea553a7eb6808a4a9a02a'
LocalSupport::Application.config.secret_key_base = ENV['MYAPP_SECRET_KEY_BASE'] || '20af600cc96db70dedfb207b9608c9ee0b0ad0dcfed270c02c870b0a6d45312821f996cc04aa43e7d0a504d6d6c3b514c07529bad3fb1e7f262f88df615b73b5'
