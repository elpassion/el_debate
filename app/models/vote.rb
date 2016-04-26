class Vote < ApplicationRecord
  belongs_to :answer

  validates :answer_id, presence: true
end
