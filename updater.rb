require 'octokit'
require 'github/markdown'
require 'open-uri'
require 'fileutils'
require './database'

def update
  unless File.directory?("cache")
    FileUtils.mkdir("cache")
  end

  Octokit.contents("bananita/SOMANYAPPS-BLOG-CONTENT").each do |c| 
    url = c.attrs[:_links][:html]
    
    url["github.com"] = "raw.github.com"
    url["/blob/"] = "/"
    
    puts url
    
    open(url) do |f|
      content = GitHub::Markdown.render_gfm(f.read())
      article = Article.new content: content
      article.save
    end
    File.open("cache/main_cache", 'w') { |file| file.write(@content) }
  end
end

