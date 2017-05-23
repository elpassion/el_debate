class Slack::UserMaker < ApplicationJob
  mattr_accessor :slack_api_client
  self.slack_api_client = Slack::ApiClient.build

  def perform(params)
    user_api_data = slack_api_client.get_user_data(
      params.fetch(:slack_user_id)
    )

    user = Slack::User.create!(
      slack_id: params.fetch(:slack_user_id),
      name: user_api_data.fetch(:user_name),
      image_url: user_api_data.fetch(:user_image_url)
    )

    CommentMaker.call(params.merge(user_id: user.id))
    user
  rescue Slack::ApiNetworkError => e
    Rails.logger.error e
    false
  end
end
