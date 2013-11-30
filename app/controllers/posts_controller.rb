require 'octokit'
require 'github/markdown'
require 'open-uri'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    expires_in 30.minutes, :public => true
    Octokit.configure do |c|
      c.login = 'bananita'
      c.password = 'g6GHx0gNXid*Js3'
    end

    @content = ""
    
    Octokit.contents("bananita/SOMANYAPPS-BLOG-CONTENT").each do |c|
      url = c.attrs[:_links][:html]
      
      url["github.com"] = "raw.github.com"
      url["/blob/"] = "/"
      
      open(url) do |f|
        @content += GitHub::Markdown.render_gfm(f.read())
      end
    end
   
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @code = GitHub::Markdown.render_gfm(Base64.decode64 Octokit.readme('bananita/mbfaker').content.to_s)
  end
  
  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content)
    end
end
