class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_user

  private
    def authenticate_user
      header = request.headers['Authorization']
      header = request.split(' ').last if header
      begin
        @decoded = jwt_decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {errors: e.message }, status: :authorized
      rescue JWT::DecodeError => e
        render json: {errors: e.message }, status: :authorized
      end
    end
end
