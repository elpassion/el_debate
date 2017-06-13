class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate

  def create
    debate = Debate.find_by code: params[:code]
    return render json: { error: 'Debate not found' }, status: :not_found unless debate
    form = MobileUserForm.new(::MobileUser.new)
    if form.validate(user_params.merge(auth_token: debate.auth_tokens.create!))
      form.save(validate: false)
      render json: { auth_token: form.auth_token.value, debate_closed: debate.closed? }
    else
      render json: { error: form.errors.full_messages.join('. ') }, status: :bad_request
    end
  end

  private

  def user_params
    { name: params[:username] }
  end
end
