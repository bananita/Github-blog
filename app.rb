require 'rubygems'  
require 'sinatra' 
require './updater'
require './database'

post '/post-receive-hook' do
  update
  'updating'
end

get '/' do
  @content = ""

  Article.all.each do |article|
    @content += article.content
  end 
  
  erb :blog
end  
