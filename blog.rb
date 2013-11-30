require 'rubygems'  
require 'sinatra' 
require 'octokit'
require 'github/markdown'
require 'open-uri'

get '/' do
  if File.exist?("timestamp")
    timestamp = File.read("timestamp").to_i
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
      File.open("yourfile", 'w') { |file| file.write(@content) }
      File.open("timestamp", 'w') { |file| file.write(Time.now.to_i.to_s) }
    end
  else 
    puts "getting data from cache"
    @content = File.read("yourfile")
  end
  
  
  erb :blog
end  
