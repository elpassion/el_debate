class MobileComment < Comment
  belongs_to :user, foreign_key: :user_id, class_name: MobileUser
end
