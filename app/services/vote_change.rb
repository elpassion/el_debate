class VoteChange

  def initialize(answer, previous_vote)
    @answer = answer
    @previous_vote = previous_vote
    @positive = 0
    @negative = 0
    calculate_change
  end

  def to_h
    {
      vote_change:
        {
           positive: positive,
           negative: negative
        }
    }
  end

  private

  attr_reader :answer, :previous_vote, :positive, :negative

  def calculate_change
    add_vote_to_change_hash if previous_vote
    add_to_change_hash(answer, +1)
  end

  def add_vote_to_change_hash
    add_to_change_hash(previous_vote.answer, -1)
  end

  def add_to_change_hash(answer, counter)
    if answer.positive?
      @positive +=  counter
    elsif answer.negative?
      @negative += counter
    end
  end
end
