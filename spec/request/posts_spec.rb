require 'rails_helper'
require 'database_cleaner/active_record'

RSpec.describe "Posts", type: :request do
  $authentication_token
  before(:all) do
    @user = create(:user)
    params = {
      registration: {
        email: @user.email,
        username: @user.username,
        password: @user.password,
        password_confirmation: @user.password_confirmation
      }
    }
    post "/api/users", params: params,  as: :json
  end
  before(:all) do
    params = {
        username: @user.username,
        password: @user.password
    }
    post "/api/users/sign_in", params: params,  as: :json
    parsed_body = JSON.parse(response.body)
    $authentication_token = parsed_body['authentication_token']
  end
  before(:all) do
      title = Faker::Quote.matz
      params = {
        title: title,
        photo: fixture_file_upload(Rails.root.to_s + '/spec/fixtures/files/netquest.png', 'image/png'),
        user_id: @user.id
      }
      post "/api/posts", headers: {token: $authentication_token}, params: params,  as: :json
      @post = JSON.parse(response.body)
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "GET /index" do
    it "Unauthorized user" do
      get "/api/posts", headers: {token: "sjdsdjsjdjksdk"},as: :json
      response_message = JSON.parse(response.body)["message"]
      expect(response_message).to eq("Unauthorized User")
      expect(response).to have_http_status(401)
    end
    it "return http success" do
      get "/api/posts", headers: {token: $authentication_token},as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "Unauthorized user" do
      params = {
        title: Faker::Quote.matz,
        photo: fixture_file_upload(Rails.root.to_s + '/spec/fixtures/files/netquest.png', 'image/png'),
        user_id: @user.id
      }
      post "/api/posts", headers: {token: "jsdjsdjdjn"}, params: params,  as: :json
      response_message = JSON.parse(response.body)["message"]
      expect(response_message).to eq("Unauthorized User")
      expect(response).to have_http_status(401)
    end
    it "post is created" do
      title = Faker::Quote.matz
      params = {
        title: title,
        photo: fixture_file_upload(Rails.root.to_s + '/spec/fixtures/files/netquest.png', 'image/png'),
        user_id: @user.id
      }
      post "/api/posts", headers: {token: $authentication_token}, params: params,  as: :json
      expect(JSON.parse(response.body)['title']).to eq(title)
      expect(JSON.parse(response.body)['user_id']).to eq(@user.id)
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET /show" do
    it "Unauthorized user" do
      get "/api/posts/", params: {id: 1}, headers: {token: "jsdjsdjdjn"},  as: :json
      response_message = JSON.parse(response.body)["message"]
      expect(response_message).to eq("Unauthorized User")
      expect(response).to have_http_status(401)
    end
    it "does show aggregate information of the post" do
      get "/api/posts/"+@post["id"].to_s, headers: {token: $authentication_token},  as: :json
      expect(JSON.parse(response.body)['title']).to eq(@post['title'])
      expect(JSON.parse(response.body)['id']).to eq(@post['id'])
      expect(response).to have_http_status(:success)
    end
  end
  describe "PUT /update" do
    it "does update the post" do
      title = Faker::Quote.matz
      params = {
        title: title,
        photo: fixture_file_upload(Rails.root.to_s + '/spec/fixtures/files/netquest.png', 'image/png'),
        user_id: @user.id
      }
      put "/api/posts/"+@post["id"].to_s, headers: {token: $authentication_token}, params: params,  as: :json
      expect(JSON.parse(response.body)['message']).to eq("post update successfully")
      expect(response).to have_http_status(:success)
    end
  end
  describe "DELETE /destroy" do
    it "Unauthorized user" do
      get "/api/posts/", params: {id: 1}, headers: {token: "jsdjsdjdjn"},  as: :json
      response_message = JSON.parse(response.body)["message"]
      expect(response_message).to eq("Unauthorized User")
      expect(response).to have_http_status(401)
    end
    it "does delete the post" do
      delete "/api/posts/"+@post["id"].to_s, headers: {token: $authentication_token},  as: :json
      expect(JSON.parse(response.body)['message']).to eq("Post is deleted successfully")
      expect(response).to have_http_status(:success)
    end
  end
end
