class Api::Edge::CommentsController < Api::CommentsController
  private

  def update_user_identity
    UserIdentity.new(@user).update(first_name: params.fetch(:first_name),
                                   last_name: params.fetch(:last_name))
  end
end
