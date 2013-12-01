require 'rubygems'  
require 'sinatra' 
require 'octokit'
require 'github/markdown'
require 'open-uri'

post '/post-receive-hook' do
  unless File.directory?("cache")
    FileUtils.mkdir("cache")
  end
  
  Octokit.contents("bananita/SOMANYAPPS-BLOG-CONTENT").each do |c| 
    url = c.attrs[:_links][:html]
    
    url["github.com"] = "raw.github.com"
    url["/blob/"] = "/"
    
    puts url
    
    open(url) do |f|
      @content += GitHub::Markdown.render_gfm(f.read())
    end
    File.open("cache/main_cache", 'w') { |file| file.write(@content) }
  end
end

get '/' do
  puts "getting data from cache"
  @content = File.read("cache/main_cache")
  
  erb :blog
end  
