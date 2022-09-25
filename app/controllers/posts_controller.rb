class PostsController < ApplicationController

    before_action :authenticate_user!, only: [:create, :update]

    rescue_from Exception do |e|
        render json: {error: e.message}, status: :internal_error
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end


    #GET /posts
    def index 
        @posts = Post.where(published: true)
        if !params[:search].nil? && params[:search].present?
            @posts = PostsSearchService.search(@posts, params[:search])
        end

        render json: @posts.includes(:user), status: :ok
    end
    
    # GET /posts/{id}
    def show
        @post = Post.find(params[:id])
        render json: @post, status: :ok
    end

    # POST /posts
    def create 
        @post = Post.create!(create_params)
        render json: @post, status: :created
    end

    # PUT /posts/{id}
    def update
        @post = Post.find(params[:id])
        @post.update!(update_params)
        render json: @post, status: :ok
    end

    private

    def create_params
        params.require(:post).permit(:title, :content, :published, :user_id)
    end

    def update_params
        params.require(:post).permit(:title, :content, :published)
    end

    def authenticate_user!
        # Bearer xxxx
        token_regex = /Bearer (\w+)/

        # read header auth
        headers = request.headers

        # verify it's valid
        if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
            token = headers['Authorization'].match(token_regex)[1]
            if (Current.user = User.find_by_auth_token(token))
                return 
            end

        end

        render json: {error: 'Unauthorized'}, status: :unauthorized
        # verify token belongs to user

    end
end