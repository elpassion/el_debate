class   GetComments
  def to_h
    comments = Comment.where(debate_id: debate_id)
    comments.map { |comment| CommentSerializer.new(comment).to_h }
  end

  private
  attr_accessor :debate_id

  def initialize(debate_id)
    @debate_id = debate_id
  end
end
