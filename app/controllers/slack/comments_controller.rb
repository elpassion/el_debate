class Slack::CommentsController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from StandardError do |e|
    Rails.logger.error e
    render json: Slack::ResponseSerializer.in_channel(
      "There was a problem submitting your comment"
    )
  end

  def help
    render json: Slack::ResponseSerializer.not_public(
      "Please provide the comment content."
    )
  end

  def create
    if debate && user
      CommentMaker.perform(debate: debate, user: user, params: comment_params)
    else
      Slack::UserMaker.perform_later(user_params)
    end

    render json: Slack::ResponseSerializer.in_channel(
      "Your comment was submitted."
    )
  rescue ActiveRecord::RecordNotFound
    render json: Slack::ResponseSerializer.in_channel(
      "Your channel is not assigned to any active debate."
    )
  end

  private

  def comment_params
    { content: params.fetch(:text) }
  end

  def user_params
    { slack_user_id: params.fetch(:user_id) }
  end

  def debate
    @_debate ||= Debate.opened_for_channel!(
      params.fetch(:channel_name)
    )
  end

  def user
    @_user ||= SlackUser.find_by(
      slack_id: params.fetch(:user_id)
    )
  end
end
