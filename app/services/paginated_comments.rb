class PaginatedComments
  DEFAULT_LIMIT = 10

  def initialize(debate:, direction:, params:)
    @params = params
    debate = debate
    start_at = position
    direction = direction
    @limit = limit
    @comments_stream = ARStream.build(direction, debate.retrieve_comments, start_at: start_at)
  end

  def retrieve_comments
    comments_stream.next(limit).map { |comment| CommentSerializer.new(comment) }
  end

  private

  attr_reader :limit, :comments_stream, :params


  def limit
    limit = params[:limit].to_i
    return DEFAULT_LIMIT if limit.zero?

    limit
  end

  def position
    position = params[:position].to_i
    return nil if position.zero?

    position
  end
end
