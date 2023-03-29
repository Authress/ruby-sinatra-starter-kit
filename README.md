# Authress Starter Kit: Ruby Sinatra

A repository that contains a Ruby Sinatra example that uses [Authress](https://authress.io) to Login.

## Getting Started
This repo uses ruby `bundler` to install dependencies:

```sh
gem install bundler
bundle install
bundle exec rerun 'rackup'
# OR just: bundle exec puma
# OR: bundle exec ruby -W2 src/app.rb -s Puma
```

## Configuration
Set the Authress block in the app.rb to match your account

```rb
AuthressSdk.configure do |config|
  # config.base_url = 'https://login.company.com'
  # Get a service client access key at https://authress.io/app/#/settings?focus=clients
  client_access_key = 'sc_001.b3bB.acc_001.MC4C_KEY'
  config.token_provider = AuthressSdk::ServiceClientTokenProvider.new(client_access_key)
end
```