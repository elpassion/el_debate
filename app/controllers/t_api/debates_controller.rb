class TApi::DebatesController < TApi::ApplicationController
  def show
    debate = Debate.find_by! code: params[:code]
    positive = debate.answers.find_by! answer_type: Answer::ANSWER_TYPES[:positive]
    neutral = debate.answers.find_by! answer_type: Answer::ANSWER_TYPES[:neutral]
    negative = debate.answers.find_by! answer_type: Answer::ANSWER_TYPES[:negative]

    render json: {
      topic: debate.topic,
      totalCount: debate.votes.count,
      answers: {
        positive: {
          id: positive.id,
          value: positive.value,
          count: positive.votes.count
        },
        neutral: {
          id: neutral.id,
          value: neutral.value,
          count: neutral.votes.count
        },
        negative: {
          id: negative.id,
          value: negative.value,
          count: negative.votes.count
        }
      }
    }
  end

  def create
    debate = Debate.create! topic: params[:topic]
    debate.answers.find_by!(answer_type: Answer::ANSWER_TYPES[:positive]).update value: params[:positive]
    debate.answers.find_by!(answer_type: Answer::ANSWER_TYPES[:neutral]).update value: params[:neutral]
    debate.answers.find_by!(answer_type: Answer::ANSWER_TYPES[:negative]).update value: params[:negative]

    render json: { code: debate.code }
  end
end
