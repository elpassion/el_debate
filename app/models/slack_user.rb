class SlackUser < ApplicationRecord
  has_many :comments, as: :user
end

