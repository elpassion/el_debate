class SlackUser < ApplicationRecord
  has_many :slack_comments, foreign_key: :id
end

