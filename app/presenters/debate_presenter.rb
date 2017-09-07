class DebatePresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def positive_count_with_person
    pluralize(positive_count, 'person')
  end

  def negative_count_with_person
    pluralize(negative_count, 'person')
  end

  def positive_percent
    return '0%' if opinions_count.zero?
    "#{(positive_count / opinions_count.to_f * 100.0).round}%"
  end

  def negative_percent
    return '0%' if opinions_count.zero?
    "#{(negative_count / opinions_count.to_f * 100.0).round}%"
  end

  def positive_value
    positive_answer.value
  end

  def negative_value
    negative_answer.value
  end

  def neutral_value
    neutral_answer.value
  end

  def votes_count
    opinions_count + neutral_count
  end

  def status
    closed? ? 'closed' : 'open'
  end

  def last_comments_json(count: 5)
    last_comments(count: count)
      .map { |comment| CommentSerializer.new(comment) }
      .to_json
  end

  private

  def opinions_count
    positive_count + negative_count
  end
end
