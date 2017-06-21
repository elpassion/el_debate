class MobileUser < ApplicationRecord
  has_many :mobile_comments, foreign_key: :id
  belongs_to :auth_token
  validates :name, :auth_token, presence: true

  def image_url
    AvatarGenerator.new(auth_token.value).generate_url
  end
end

