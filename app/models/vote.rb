class Vote < ApplicationRecord
  belongs_to :answer
  belongs_to :auth_token
end
