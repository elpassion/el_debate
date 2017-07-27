class Api::Edge::CommentsController < Api::CommentsController
  private

  def update_mobile_user_identity
    MobileUserIdentity.new(@mobile_user, params).call
  end
end
