class MobileUser < ApplicationRecord
  belongs_to :auth_token
  has_many :comments, as: :user

  validates :name, :auth_token, presence: true

  def image_url
    AvatarGenerator.new(auth_token.value).generate_url
  end
end