class ApplicationController < ActionController::API
  def authenticate_user_from_id_and_token!

    @current_user = User.find_by_authentication_token(request.headers[:token])
    if @current_user.nil?
      render json: {success: false, message: "Unauthorized User"}, status: 401
    end

  end
end
