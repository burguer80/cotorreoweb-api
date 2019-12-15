require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Posts', type: :request do

  describe 'GET Posts' do
    before { get '/posts' }

    it 'should return OK' do
      expect(payload).not_to be_empty
      expect(response).to have_http_status(200)
    end

    describe 'with DB data' do
      let!(:posts) { create_list(:post, 10, status: :published) }
      before { get '/posts' }

      it 'should return published posts' do
        expect(payload['data'].size).to eq(posts.size)
      end
    end
  end

  describe 'GET /post/{id}' do
    let!(:post) { create(:post) }

    it 'should return a post' do
      get "/posts/#{post.id}"
      expect(payload).not_to be_empty
      expect(payload['data']['id'].to_i).to eq(post.id)
      expect(payload['data']['attributes']['title']).to eq(post.title)
      expect(payload['data']['attributes']['body']).to eq(post.body)
      expect(payload['data']['attributes']['status']).to eq(post.status)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user) }

    it 'should create a post' do
      post '/posts', params: valid_payload, headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(payload['data']['id']).not_to be_empty
      expect(response).to have_http_status(:created)
    end

    it 'should return error message on invalid post' do
      post '/posts', params: invalid_payload, headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /posts' do
    let!(:user) { create(:user) }
    let!(:article) { create(:post) }

    it 'should update a post' do
      put "/posts/#{article.id}", params: valid_payload, headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(payload['data']['id'].to_i).to eq(article.id)
      expect(payload['data']['attributes']['title']).to eq(valid_payload[:post][:title])
      expect(payload['data']['attributes']['body']).to eq(valid_payload[:post][:body])
      expect(payload['data']['attributes']['status']).to eq(valid_payload[:post][:status])
      expect(response).to have_http_status(:ok)
    end

    it 'should return error message on invalid post' do
      put "/posts/#{article.id}", params: invalid_payload, headers: valid_auth_headers(user)
      expect(payload).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  private

  def invalid_payload
    {
      post: {
        title: nil,
        body: nil,
        status: 'draft'
      }
    }
  end

  def payload
    JSON.parse(response.body)
  end

  def valid_payload
    {
      post: {
        title: 'Title',
        body: 'Body',
        status: 'draft'
      }
    }
  end

  def valid_auth_headers(user)
    headers = {'Accept' => 'application/json'}
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end