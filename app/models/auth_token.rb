class AuthToken < ApplicationRecord
  belongs_to :debate, required: true
  has_one :vote, required: false
  has_one :mobile_user, required: false

  has_secure_token :value
end
