class PostsController < ApplicationController

  def authenticate 
    params[:password] == 'rushrush'
  end

  # GET /posts
  def index
    @posts = Post.order('id DESC').page params[:page]
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if authenticate && @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render action: :index }
      end
    end
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if authenticate && @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
      else
        format.html { render action: :edit }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    if authenticate
      @post = Post.find(params[:id])
      @post.destroy
    end
       redirect_to posts_url 
  end

end
