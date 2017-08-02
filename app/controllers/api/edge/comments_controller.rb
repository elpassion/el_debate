class Api::Edge::CommentsController < Api::CommentsController
  private

  def update_mobile_user_identity
    MobileUserIdentity.new(@mobile_user).update(first_name: params.fetch(:first_name),
                                                last_name: params.fetch(:last_name))
  end
end
