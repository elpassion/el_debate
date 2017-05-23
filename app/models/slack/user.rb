class Slack::User < ApplicationRecord
  self.table_name = "slack_users"

  has_many :comments, foreign_key: :slack_user_id
end

