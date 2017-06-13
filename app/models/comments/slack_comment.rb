class SlackComment < Comment
  belongs_to :user, foreign_key: :user_id, class_name: SlackUser
end
