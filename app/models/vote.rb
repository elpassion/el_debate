class Vote < ApplicationRecord
  belongs_to :answer, required: true
  belongs_to :auth_token, required: true
end
