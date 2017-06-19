class MobileUser < ApplicationRecord
  has_many :mobile_comments, foreign_key: :id
  belongs_to :auth_token

  def image_url
    AvatarGenerator.new(auth_token.value).generate_avatar_url
  end
end

