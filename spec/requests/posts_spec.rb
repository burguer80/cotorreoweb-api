require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Posts', type: :request do

  describe 'GET Posts' do

    it 'should return OK' do
      get '/posts'
      expect(payload).not_to be_empty
      expect(response).to have_http_status(200)
    end

    describe 'Search' do
      let!(:first_post) { create(:published_post, title: 'First Post') }
      let!(:second_post) { create(:published_post, title: 'Second Post') }
      let!(:third_post) { create(:published_post, title: 'Third One') }

      it 'should filter posts by title' do
        get '/posts?search=Post'
        expect(payload['posts'].size).to eq(2)
      end
    end

    describe 'with DB data' do
      let!(:user) { create(:user) }
      let!(:posts) { create_list(:post, 10, status: :published, user_id: user.id) }
      before { get '/posts' }

      it 'should return published posts' do
        expect(payload['posts'].size).to eq(posts.size)
      end
    end
  end

  describe 'GET /post/{id}' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }

    it 'should return a post' do
      get "/posts/#{post.id}"
      expect(payload).not_to be_empty
      expect(payload['post']['id'].to_i).to eq(post.id)
      expect(payload['post']['title']).to eq(post.title)
      expect(payload['post']['body']).to eq(post.body)
      expect(payload['post']['status']).to eq(post.status)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user) }

    it 'should create a post' do
      post '/posts', params: valid_payload(user), headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(payload['post']['id']).to be_truthy
      expect(response).to have_http_status(:created)
    end

    it 'should return error message on invalid post' do
      post '/posts', params: invalid_payload(user), headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /posts' do
    let!(:user) { create(:user) }
    let!(:article) { create(:post, user_id: user.id) }

    it 'should update a post' do
      put "/posts/#{article.id}", params: valid_payload(user), headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(payload['post']['id'].to_i).to eq(article.id)
      expect(payload['post']['title']).to eq(valid_payload(user)[:post][:title])
      expect(payload['post']['body']).to eq(valid_payload(user)[:post][:body])
      expect(payload['post']['status']).to eq(valid_payload(user)[:post][:status])
      expect(response).to have_http_status(:ok)
    end

    it 'should return error message on invalid post' do
      put "/posts/#{article.id}", params: invalid_payload(user), headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  private

  def invalid_payload(user)
    {
      post: {
        title: nil,
        body: nil,
        status: 'draft',
        user_id: user.id
      }
    }
  end

  def payload
    JSON.parse(response.body)
  end

  def valid_payload(user)
    {
      post: {
        title: 'Title',
        body: 'Body',
        status: 'draft',
        user_id: user.id
      }
    }
  end

  def valid_auth_headers(user)
    headers = {'Accept': 'application/json'}
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end