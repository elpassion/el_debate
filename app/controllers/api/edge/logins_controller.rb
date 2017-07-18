class Api::Edge::LoginsController < Api::LoginsController
  private

  def set_mobile_user
    @mobile_user = ::Edge::MobileUser.new(mobile_user_params)
  end

  def mobile_user_params
    {
      auth_token: @auth_token
    }
  end
end
