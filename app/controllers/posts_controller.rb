class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: PostSerializer.new(@posts)
  end

  # GET /posts/1
  def show
    render json: PostSerializer.new(@post)
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: PostSerializer.new(@post), status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: PostSerializer.new(@post)
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:title, :body, :status)
  end
end
