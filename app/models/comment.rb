class Comment < ApplicationRecord
  belongs_to :debate
  belongs_to :slack_user, class_name: Slack::User, foreign_key: :slack_user_id, optional: true
  validates :content, presence: true
  delegate :image_url, :name, to: :user, prefix: true

  def user
    slack_user || self.class.anonymous_user
  end

  def self.anonymous_user
    @_anonymous_user ||= OpenStruct.new(image_url: '/assets/dashboard/default_user.png', name: 'Anonymous')
  end
end
