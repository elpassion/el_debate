class Comment < ApplicationRecord
  belongs_to :debate

  def user
  end
end
