class Slack::Comment < Comment
  belongs_to :slack_user, class_name: Slack::User, foreign_key: :slack_user_id
  validates :slack_user_id, :content, presence: true

  def user
    slack_user
  end
end
