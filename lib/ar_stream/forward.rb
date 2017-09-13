class ARStream::Forward < ARStream
  private

  def query
    query = relation.reorder(id: :asc)
    query = query.where('id >= ?', position) if position.present?
    query
  end

  def update_position!(records)
    self.position = records.last.id + 1
  end
end
