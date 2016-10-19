class AuthToken < ApplicationRecord
  belongs_to :debate
  has_secure_token :value
end
