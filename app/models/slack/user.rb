class Slack::User < ApplicationRecord
  self.table_name = "slack_users"

  has_many :comments, class_name: Slack::Comment
end

