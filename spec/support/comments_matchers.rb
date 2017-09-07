module CommentsMatchers
  def look_like_comment_json
    match(
      "id"                             => be_a_kind_of(Integer),
      "content"                        => be_a_kind_of(String),
      "full_name"                      => be_a_kind_of(String),
      "created_at"                     => be_a_kind_of(Integer),
      "user_initials_background_color" => be_a_kind_of(String),
      "user_initials"                  => be_a_kind_of(String),
      "user_id"                        => be_a_kind_of(Integer),
      "status"                         => be_a_kind_of(String)
    )
  end
end
