class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.where(status: :published)
    render json: PostSerializer.new(@posts), status: :ok
  end

  # GET /posts/1
  def show
    render json: PostSerializer.new(@post), status: :ok
  end

  # POST /posts
  def create
    @post = Post.create!(post_params)
    render json: PostSerializer.new(@post), status: :created, location: @post
  end

  # PATCH/PUT /posts/1
  def update
    @post.update!(post_params)
    render json: PostSerializer.new(@post)
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
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
