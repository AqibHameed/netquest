# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
=begin
@api {post} api/users Request sign_up User
@apiName create
@apiGroup Registrations
@apiDescription sign_up user
@apiBody {json} body
{
  "registration": {
  	            "email":"aqibpadana@gmail.com",
  	            "username":"aqib",
  	            "password":"aqib123",
  	            "password_confirmation":"aqib123"
             }

}
@apiSuccessExample {json} SuccessResponse:
{
    "id": 1,
    "email": "aqibpadana@gmail.com",
    "username": "aqib",
    "password": "aqib123"
}
=end
  def create
    @user = User.new(user_params)
    @user.authentication_token = Devise.friendly_token
    if @user.save
      render status: :created, template: "devise/registrations/sign_up"
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  protected
  def user_params
    params.require(:registration).permit( :email, :username, :password, :password_confirmation)
  end
end
