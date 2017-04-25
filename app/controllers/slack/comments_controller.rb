class Slack::CommentsController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from StandardError do |e|
    Rails.logger.error e
    render json: {
      response_type: "in_channel",
      text: "There was a problem submitting your comment"
    }
  end

  def help
    render json: {
      response_type: "ephemeral",
      text: "Please provide the comment content."
    }
  end

  def create
    if debate && user
      Slack::CommentMaker.call(comment_maker_params)
    else
      Slack::UserMaker.perform_later(user_maker_params)
    end

    render json: {
      response_type: "in_channel",
      text: "Your comment was submitted."
    }
  rescue ActiveRecord::RecordNotFound
    render json: {
      response_type: "in_channel",
      text: "Your channel is not assigned to any active debate."
    }
  end

  private

  def comment_maker_params
    {
      user_id: user&.id,
      slack_user_id: params.fetch(:user_id),
      debate_id: debate.id,
      comment_text: params.fetch(:text)
    }
  end

  def user_maker_params
    comment_maker_params.slice(:slack_user_id, :debate_id, :comment_text)
  end

  def debate
    @_debate ||= Debate.opened_for_channel!(
      params.fetch(:channel_name)
    )
  end

  def user
    @_user ||= Slack::User.find_by(
      slack_id: params.fetch(:user_id)
    )
  end
end
