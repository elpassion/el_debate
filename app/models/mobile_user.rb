class MobileUser < ApplicationRecord
  has_many :mobile_comments, foreign_key: :id
  belongs_to :auth_token

  def image_url
    "https://api.adorable.io/avatars/80/#{auth_token.value}.png"
  end
end

