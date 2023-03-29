require 'cgi'
require 'rest-client'
require 'json'
require 'securerandom'
require 'base64'
require 'openssl'
require 'authress-sdk'
require 'rubygems'
require 'sinatra'
require "sinatra/base"
require "sinatra/cookies"

##########################################################################################
##########################################################################################

# create an instance of the API class during service initialization
# Replace the base_url with the custom Authress domain for your account
# https://authress.io/app/#/settings?focus=domain
AuthressSdk.configure do |config|
  # config.base_url = 'https://login.company.com'
  config.base_url = 'https://authress-test.authress.com'
  # Get a service client access key at https://authress.io/app/#/settings?focus=clients
  client_access_key = 'sc_001.b3bB.acc_001.MC4C_KEY'
  config.token_provider = AuthressSdk::ServiceClientTokenProvider.new(client_access_key)
end
# Specify your application identifier or generate a new one: https://authress.io/app/#/settings?focus=applications
application_id = 'app_w5JRgS8hnEc1eKbXsojvn1'
login_client = AuthressSdk::LoginApi.new(application_id)

##########################################################################################
##########################################################################################
configure do
  enable :sessions
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

get '/' do
  current_location = URI(request.url)
  query = CGI::parse(current_location.query || '')

  access_token = cookies[:authorization] || query["access_token"]
  user_identity_token = cookies[:user] || query["id_token"]
  puts "User Access Token:", access_token
  puts "User Identity Data:",  user_identity_token

  jwt_payload = user_identity_token && user_identity_token.to_s && user_identity_token.to_s.split('.')[1]
  if jwt_payload
    jwt_payload += '=' * (4 - jwt_payload.length.modulo(4))
    user_identity = JSON.parse(Base64.decode64(jwt_payload.tr('-_','+/')))
    puts user_identity
  end

  erb :'index', { :locals => { :user_identity => user_identity, :access_token => access_token } }
end

get '/login' do
  current_location = URI(request.url)
  current_location.path = "/"

  authentication_url, code_verifier = login_client.authenticate({
    # url to redirect the user to after login
    :redirect_url => current_location.to_s,

    # Force using this connection
    :connection_id => 'google'
    # Or let the user choose their own tenant
    # :tenant_lookup_identifier => 'tenant_001'
  })
  redirect authentication_url
end
