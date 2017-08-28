ActiveAdmin.register Comment do
  belongs_to :debate
  actions :all, :except => [:show, :edit]

  index do
    selectable_column
    id_column
    column :content
    column :status
    column :created_at
    actions do |comment|
      if comment.accepted?
        item "reject", reject_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link'
      elsif comment.pending?
        item "accept", accept_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link'
        item "reject", reject_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link'
      else
        item "accept", accept_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link'
      end
    end
    render partial: 'admin/store_code_debate', locals: { debate_code: debate.code, debate_id: debate.id }
  end

  member_action :accept, method: :put do
    debate = resource.debate
    resource.accepted!
    CommentNotifier.new.send_comment(resource, "dashboard_channel_#{debate.code}")
    redirect_back fallback_location: resource_url, alert: "Status was changed"
  end

  member_action :reject, method: :put do
    resource.rejected!
    redirect_back fallback_location: resource_url, alert: "Status was changed"
  end

  batch_action :accept do |ids|
    debate = Debate.find_by_id!(params[:debate_id])
    comments = debate.comments.where(id: ids).update(status: :accepted)

    CommentNotifier.new.send_comments(comments, "dashboard_channel_multiple_#{debate.code}")
    redirect_back fallback_location: admin_debate_comments_url, alert: " Status was changed"
  end

  batch_action :reject do |ids|
    Comment.where(id: ids).update(status: :rejected)
    redirect_back fallback_location: admin_debate_comments_url, alert: " Status was changed"
  end

  batch_action :destroy do |ids|
    Comment.where(id: ids).destroy_all
    redirect_back fallback_location: admin_debate_comments_url, alert: "#{ids.count} comments deleted"
  end
end
