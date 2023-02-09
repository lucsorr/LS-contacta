require 'sinatra'
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'

get '/' do
  'Getting started.'
end