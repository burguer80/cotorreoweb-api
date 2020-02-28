class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.where(status: :published)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end

    render json: serialized_posts, status: :ok
  end

  # GET /posts/1
  def show
    render json: serialized_post, status: :ok
  end

  # POST /posts
  def create
    @post = Post.create!(post_params)
    render json: serialized_post, status: :created, location: @post
  end

  # PATCH/PUT /posts/1
  def update
    @post.update!(post_params)
    render json: serialized_post
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
  end

  private

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:title, :body, :status, :user_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def serialized_post
    @post.as_json(only: [:id, :title, :body, :status, :created_at, :updated_at], include: {
      user: {
        only: [:id, :name, :last_name]
      }
    })
  end

  def serialized_posts
    @posts.as_json(only: [:id, :title], include: {
      user: {
        only: [:id, :name, :last_name]
      }
    })
  end

end
