class Api::PostsController < ApplicationController
  before_action :authenticate_user_from_id_and_token!
  def index
    @posts = Post.all
    render status: :ok, template: "/post/index"
  end
=begin
@api {post} api/posts Request Create Post
@apiName create
@apiGroup Post
@apiDescription create post
@apiHeader {String} token 6vuxxgHiwrSWazwVWSuV.
@apiBody {file} photo image_content
@apiBody {string} title When dreams come true.
@apiBody {Number} id  User reference ID
@apiSuccessExample {json} SuccessResponse:
{
    "id": 7,
    "title": "When dreams come true.",
    "created_at": "2022-05-20T05:37:43.605Z",
    "updated_at": "2022-05-20T05:37:43.641Z",
    "user_id": 1,
    "img": "https://netquest-bucket.s3.amazonaws.com/dtac9wlf7ol85vyp5yiyyhwvftk1?response-content-disposition=inline%3B%20filename%3D%22map.png%22%3B%20filename%2A%3DUTF-8%27%27map.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYBLN57YYFB52CNI7%2F20220520%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220520T053745Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=a52e36bc9e511b44683a745d697b2fb1b4f0bd6f12bf1f16c3f2dde5d7840204"
}
=end
  def create
    @post = Post.new(post_params)
    if @post.save
        render status: :ok , template: "post/create"
    else
        render status: :unprocessable_entity, json: {errors: @post.errors.full_messages}
    end
    end
=begin
@api {get} api/posts/:id Request Post information
@apiName show
@apiGroup Post
@apiDescription get only single aggregate information of  post

@apiParam {Number} id Posts unique ID.
@apiHeader {String} token 6vuxxgHiwrSWazwVWSuV.
@apiSuccessExample {json} SuccessResponse:
     {
       "id": 4,
       "title": "When dreams come true.",
       "user_id": 1,
       "img": "https://netquest-bucket.s3.amazonaws.com/oh8p45cp8c9huj1ytkvc4f3j06pm?response-content-disposition=inline%3B%20filename%3D%22map.png%22%3B%20filename%2A%3DUTF-8%27%27map.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYBLN57YYFB52CNI7%2F20220519%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220519T203306Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=1f37659d08b18b92276a4e53e370f0df60a74f7c7bbcd04ea6470aa0af9b6266"
     }
=end
  def show
    @post = Post.find_by(id:params[:id])
    if @post.present?
      render status: :ok, template: "post/show"
    else
      render status: :not_found, json: {errors: "Post is not exist with Id "+ params[:id]}
    end
  end
=begin
@api {put} api/posts/:id Request Update Post
@apiName update
@apiGroup Post
@apiDescription update post
@apiParam {Number} id Posts unique ID.
@apiHeader {String} token 6vuxxgHiwrSWazwVWSuV.
@apiBody {file} photo image_content
@apiBody {string} title This sweet lady was dumped at the lake today. Coldest day of the year.
@apiSuccessExample {json} SuccessResponse:
 {
   "message": "post update successfully"
 }
=end

  def update
    post = Post.find_by_id(params[:id])
    if post.present?
      if post.update(post_params)
        render status: :ok , json: {message: "post update successfully"}
      else
        render json: post.errors, status: :unprocessable_entity
      end
    else
      render status: :not_found, json: {errors: "Post is not exist with Id "+ params[:id]}
    end
  end
=begin
@api {get} api/posts/:id Request Post delete
@apiName delete
@apiGroup Post
@apiDescription delete post

@apiParam {Number} id Posts unique ID.
@apiHeader {String} token 6vuxxgHiwrSWazwVWSuV.
@apiSuccessExample {json} SuccessResponse:
     {
       "message": "Post is deleted successfully"
     }
=end
  def destroy
    post = Post.find_by(id:params[:id])
    if post.present?
      post.photo.purge_later
      post.destroy!
      render status: :ok , json: {message: "Post is deleted successfully"}
    else
      render status: :not_found, json: {errors: "Post is not exist with Id "+ params[:id]}
    end
  end

  private
  def post_params
    params.permit(:title, :photo, :user_id)
  end
end
