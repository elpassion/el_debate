class Slack::Comment < ApplicationRecord
  self.table_name = "slack_comments"
  belongs_to :slack_user, class_name: Slack::User, foreign_key: :slack_user_id
  belongs_to :debate
  validates :slack_user_id, :content, presence: true

  delegate :name, :image_url, to: :slack_user, prefix: true
end

