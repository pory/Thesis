require 'rubygems'
require 'sinatra'
require 'haml'
require 'models/thesis'
require 'models/chapter'
require 'models/tryruby'
require 'helpers/application'

set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'
set :haml, :format => :html5
set :markdown

get '/diplomova-prace' do
  @chapter = Thesis.find(:root)
  haml :index
end

get '/diplomova-prace/:chapter' do
  @chapter = Thesis.find(params[:chapter])
  haml :chapter
end

get '/diplomova-prace/:chapter/:section' do
  @chapter = Thesis.find(params[:chapter] + "/" + params[:section])
  haml :chapter
end

get '/interpret' do
  TryRuby.run_line(params[:code]).format
end
