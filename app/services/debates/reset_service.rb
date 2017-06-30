module Debates
  class ResetService < DebateService
    def call
      debate.votes.update_all answer_id: debate.neutral_answer.id
    end
  end
end
