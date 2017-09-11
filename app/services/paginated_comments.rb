class PaginatedComments
  DEFAULT_LIMIT = 10

  def initialize(comments_relation:, params:, direction: :backwards)
    @params = params
    @comments_stream = ARStream.build(direction, comments_relation, start_at: position)
  end

  def to_h
    { comments: comments, next_position: comments_stream.position }
  end

  private

  attr_reader :limit, :comments_stream, :params

  def comments
    comments_stream.next(limit).map { |comment| CommentSerializer.new(comment) }
  end

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
