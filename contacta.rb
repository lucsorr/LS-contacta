require 'sinatra'
require "sinatra/reloader" if development?
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'

get '/' do
  erb :index
end