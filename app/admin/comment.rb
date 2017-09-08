ActiveAdmin.register Comment do
  belongs_to :debate
  actions :all, :except => [:show, :edit]

  index do
    selectable_column
    id_column
    column :content
    column :full_name, sortable: :full_name do |comment|
      comment.user.full_name
    end
    column :status
    column :created_at
    actions do |comment|
      item "Reject", reject_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link' if !comment.rejected?
      item "Accept", accept_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link' if !comment.accepted?
    end
    render partial: 'admin/store_code_debate', locals: { debate_code: debate.code, debate_id: debate.id }
  end

  order_by :full_name do |order_clause|
    ["CONCAT(users.first_name, ' ', users.last_name)", order_clause.order].join(' ')
  end

  member_action :accept, method: :put do
    debate = resource.debate
    resource.accepted!

    CommentNotifier.new.comment_added(comment: resource, channel: "dashboard_channel_#{debate.code}")
    redirect_back fallback_location: resource_url, alert: "Status was changed"
  end

  member_action :reject, method: :put do
    resource.rejected!

    CommentNotifier.new.comment_rejected(comment: resource, channel: "user_channel_#{resource.user_id}")
    redirect_back fallback_location: resource_url, alert: "Status was changed"
  end

  batch_action :accept do |ids|
    debate = Debate.find_by_id!(params[:debate_id])
    comments = debate.comments.where(id: ids).update(status: :accepted)

    CommentNotifier.new.comments_added(comments: comments, channel: "dashboard_channel_multiple_#{debate.code}")
    redirect_back fallback_location: admin_debate_comments_url, alert: " Status was changed"
  end

  batch_action :reject do |ids|
    comments = Comment.where(id: ids).update(status: :rejected)

    notifier = CommentNotifier.new
    comments.each do |comment|
      notifier.comment_rejected(comment: comment, channel: "user_channel_#{comment.user_id}")
    end

    redirect_back fallback_location: admin_debate_comments_url, alert: " Status was changed"
  end

  batch_action :destroy do |ids|
    Comment.where(id: ids).destroy_all
    redirect_back fallback_location: admin_debate_comments_url, alert: "#{ids.count} comments deleted"
  end

  scope :joined, :default => true do |comments|
    comments.joins :user
  end
end
