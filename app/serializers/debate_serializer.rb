class DebateSerializer
  def initialize(debate)
    @debate = debate
  end

  def to_json
    { topic: @debate.topic, answers: answers }
  end

  private

  def answers
    @debate.answers.map do |answer|
      [answer.answer_type_key, { id: answer.id, value: answer.value }]
    end.to_h
  end
end
