class PaginatedComments
  DEFAULT_LIMIT = 10

  def initialize(comments_relation:, params:, direction: :backwards)
    @params = params
    @comments_stream = ARStream.build(direction, comments_relation, start_at: position)
  end

  def call
    { comments: comments, next_position: comments_stream.position }
  end

  private

  attr_reader :comments_stream, :params

  def comments
    comments_stream.next(limit).map { |comment| CommentSerializer.serialize(comment) }
  end

  def limit
    limit = params[:limit].to_i
    return DEFAULT_LIMIT if limit.zero?

    limit
  end

  def position
    position = params[:position]
    return nil unless position.to_s =~ /^\d+$/

    position.to_i
  end
end
