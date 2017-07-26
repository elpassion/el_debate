class Api::Edge::CommentsController < Api::CommentsController
  private

  def update_first_and_last_name
    @mobile_user.update_attributes(
      first_name: params.fetch(:first_name),
      last_name:  params.fetch(:last_name)
    )
  end
end
