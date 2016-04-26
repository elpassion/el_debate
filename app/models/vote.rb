class Vote < ApplicationRecord
  belongs_to :answer
  belongs_to :auth_token

  validates :answer_id, :auth_token_id, presence: true
end
