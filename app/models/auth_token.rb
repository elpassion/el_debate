class AuthToken < ApplicationRecord
  belongs_to :debate, required: true
  has_secure_token :value
end
