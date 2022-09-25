require 'rails_helper'

RSpec.describe 'Posts with authentication', type: :request do

    let!(:user) {create(:user)}
    let!(:other_user) {create(:user)}
    let!(:user_post) {create(:post, user_id: user.id)}
    let!(:other_user_post) {create(:post, user_id: other_user.id, published: true)}
     let!(:other_user_post_draft) {create(:post, user_id: other_user.id, published: false)}
    let!(:auth_headers) { {'Authorization' => "Bearer #{user.auth_token}"} }
    let!(:other_auth_headers) { {'Authorization' => "Bearer #{other_user.auth_token}"} }

    describe 'GET /posts' do
       
    end

    describe 'GET /posts/{id}' do
        context 'with valid auth' do
            context 'when requesting sombody else post' do
                context 'when post is public' do
                    before { get "/posts/#{other_user_post.id}", headers: auth_headers }


                    #payload
                    context 'payload' do
                        subject { JSON.parse(response.body) }
                        it { is_expected.to include(:id) }
                    end

                    #response
                    context 'response' do
                        subject { response }
                        it { is_expected.to have_http_status(:ok) }
                    end
                    
                end

                context 'when post is draft' do
                     before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }

                    #payload
                    context 'payload' do
                        subject { JSON.parse(response.body) }
                        it { is_expected.to include(:error) }
                    end

                    #response
                    context 'response' do
                        subject { response }
                        it { is_expected.to have_http_status(:not_found) }
                    end
                end
            end

            context 'when requesting user post' do
            end
        end
    end

    describe 'PUT /posts' do
    end

    #  it 'should return OK' do
    #         get '/posts'
    #         payload = JSON.parse(response.body)
    #         expect(payload).to be_empty
    #         expect(response).to have_http_status(:ok)
    #     end
end