#!/usr/bin/env ruby

require 'octokit'
require 'github/markdown'
require 'open-uri'

Octokit.contents("bananita/SOMANYAPPS-BLOG-CONTENT").each do |c| 
  url = c.attrs[:_links][:html]

  url["github.com"] = "raw.github.com"
  url["/blob/"] = "/"

  open(url) do |f|
    puts GitHub::Markdown.render_gfm(f.read())
  end
end
