require 'rubygems'  
require 'sinatra' 
require 'octokit'
require 'github/markdown'
require 'open-uri'

get '/' do
  unless File.directory?("cache")
    FileUtils.mkdir("cache")
  end

  if File.exist?("cache/timestamp")
    timestamp = File.read("cache/timestamp").to_i
  else 
    timestamp = 0
  end
  @content = ""

  if Time.now.to_i-timestamp > 30
    Octokit.contents("bananita/SOMANYAPPS-BLOG-CONTENT").each do |c| 
      url = c.attrs[:_links][:html]
      
      url["github.com"] = "raw.github.com"
      url["/blob/"] = "/"
      
      puts url
      
      open(url) do |f|
        @content += GitHub::Markdown.render_gfm(f.read())
      end
      File.open("cache/main_cache", 'w') { |file| file.write(@content) }
      File.open("cache/timestamp", 'w') { |file| file.write(Time.now.to_i.to_s) }
    end
  else 
    puts "getting data from cache"
    @content = File.read("cache/main_cache")
  end  
  
  erb :blog
end  
