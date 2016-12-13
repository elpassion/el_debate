class VoteChange

  def initialize(answer, previous_votes)
    @answer = answer
    @previous_votes = previous_votes
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

  attr_reader :answer, :previous_votes, :positive, :negative

  def calculate_change
    add_collection_to_change_hash
    add_to_change_hash(answer, +1)
  end

  def add_collection_to_change_hash
    previous_votes.each do |vote|
      add_to_change_hash(vote.answer, -1)
    end
  end

  def add_to_change_hash(answer, counter)
    if answer.positive?
      @positive +=  counter
    elsif answer.negative?
      @negative += counter
    end
  end
end