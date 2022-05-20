# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_signed_out_user, only: :destroy
=begin
@api {post} api/users/sign_in Request Sign_in User
@apiName create
@apiGroup Sessions
@apiDescription sign_in user
@apiBody {string} username aqib
@apiBody {string} password aqib123
@apiSuccessExample {json} SuccessResponse:
{
    "id": 1,
    "email": "aqibpadana@gmail.com",
    "username": "aqib",
    "authentication_token": "2-KNL3sMsCVaadbW3yQF"
}
=end
  def create
    @user = User.find_by_username(params[:username])

    if @user

      @user.authentication_token =  Devise.friendly_token

      if @user.save
        if @user.valid_password?(params[:password])
          sign_in("user", @user)
          render status: :created, template: "devise/sessions/sign_in"
          return
        end
      else
        return invalid_login_attempt
      end
    end

    invalid_login_attempt
  end

end
