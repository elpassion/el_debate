class DebatePresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def positive_count_with_person
    pluralize(debate.positive_count, 'person')
  end

  def negative_count_with_person
    pluralize(debate.negative_count, 'person')
  end

  def positive_percent
    return '0%' if debate.votes_count.zero?
    "#{(debate.positive_count / debate.votes_count.to_f * 100.0).round}%"
  end

  def negative_percent
    return '0%' if debate.votes_count.zero?
    "#{(debate.negative_count / debate.votes_count.to_f * 100.0).round}%"
  end

  private

  def debate
    __getobj__
  end
end
