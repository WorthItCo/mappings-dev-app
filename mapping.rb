require 'pry'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'active_support'
require 'active_support/core_ext'

require 'worth_it_mapping'

before do
   content_type :json    
   headers 'Access-Control-Allow-Origin' => '*', 
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']  
end

get '/' do
  puts 'hello'
  binding.pry
end

get '/api/mappings/*' do
  params[:url] = params[:splat].first
  hash = {
 #   { 
      mapping: mapping
#    }, callback: params[:callback]
  }

  hash.to_json
end

options '/assets/mapping/*' do
  200
end

get '/assets/mappings/*' do
  content_type :js
  file = params[:splat].first
  headers("Access-Control-Allow-Origin" =>  "*")
  WorthItMapping.for_site(file.gsub('.js', ''))
end

def mapping
  @mapping ||= get_mapping URI.decode(params[:url])
end

def get_mapping(path)
  my_path = path.gsub(/(^http:[\/])([^\/])/i) { "#{$1}/#{$2}" }
  my_path = my_path.gsub(/(^https:[\/])([^\/])/i) { "#{$1}/#{$2}" }

  if WorthItMapping.has_mapping_for?(my_path)
    uri = URI.parse('http://localhost:4567')
    uri.merge(WorthItMapping.path_for_site(my_path)).to_s
  end
end