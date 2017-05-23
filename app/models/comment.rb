class Comment < ApplicationRecord
  belongs_to :debate
  belongs_to :slack_user, class_name: Slack::User, foreign_key: :slack_user_id
  validates :content, presence: true

  def user
    slack_user || anonymous_user
  end

  private

  def anonymous_user
    OpenStruct.new(image_url: '/assets/dashboard/default_user.png', name: 'Anonymous')
  end
end
