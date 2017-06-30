module Debates
  class ResetService < DebateService
    def call
      reset_votes
      notify_about_reset
    end

    private

    def reset_votes
      debate.votes.update_all(answer_id: debate.neutral_answer.id)
    end

    def notify_about_reset
      notifier.notify_about_reset(debate)
    end
  end
end
