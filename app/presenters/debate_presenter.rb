class DebatePresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def positive_count_with_person
    pluralize(positive_count, 'person')
  end

  def negative_count_with_person
    pluralize(negative_count, 'person')
  end

  def positive_percent
    return '0%' if votes_count.zero?
    "#{(positive_count / votes_count.to_f * 100.0).round}%"
  end

  def negative_percent
    return '0%' if votes_count.zero?
    "#{(negative_count / votes_count.to_f * 100.0).round}%"
  end

  def votes_count
    positive_count + negative_count
  end
end
