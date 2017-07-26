class Api::Edge::CommentsController < Api::CommentsController
  before_action :update_first_and_last_name, unless: :first_and_last_name_present?

  private

  def set_mobile_user
    @mobile_user = MobileUser.find_by(auth_token: @auth_token)
  end

  def update_first_and_last_name
    @mobile_user.update_attributes(
      first_name: params.fetch(:first_name),
      last_name:  params.fetch(:last_name)
    )
  end

  def first_and_last_name_present?
    @mobile_user.first_name.present? && @mobile_user.last_name.present?
  end
end
