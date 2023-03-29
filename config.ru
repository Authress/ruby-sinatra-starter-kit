# config.ru

require './src/app.rb'
run Sinatra::Application
set :bind, '127.0.0.1'