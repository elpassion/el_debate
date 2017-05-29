class DebateSerializer
  def initialize(debate, auth_token_id)
    @debate = debate
    @auth_token_id = auth_token_id
  end

  def to_json
    {
      topic: @debate.topic,
      answers: answers,
      last_answer_id: last_answer_id
    }
  end

  private

  def answers
    @debate.answers.map do |answer|
      [answer.answer_type_key, { id: answer.id, value: answer.value }]
    end.to_h
  end

  def last_answer_id
    @debate.votes.find_by(auth_token_id: @auth_token_id)&.answer_id
  end
end
