ActiveAdmin.register Debate do
  permit_params :topic

  index do
    selectable_column
    id_column
    column :topic
    column :code
    column :created_at
    column :closed_at
    actions do |debate|
      link_to('Close', close_admin_debate_path(debate), method: :put) unless debate.closed?
    end
  end

  show title: proc{|debate| debate.topic } do
    attributes_table do
      row :topic
      row :code
      row :closed_at do |debate|
        if debate.closed_at?
          debate.closed_at
        else
          link_to('Close', close_admin_debate_path(debate), method: :put)
        end
      end
      row :answers do |debate|
        debate.answers.map do |answer|
          link_to answer.value, admin_debate_answer_path(debate, answer.id)
        end.join(', ').html_safe
      end
      row 'All votes' do |debate|
        debate.votes_count
      end

      debate.answers.each do |answer|
        row %Q(Votes for "#{answer.value}") do
          answer.votes_count
        end
      end
    end
  end

  member_action :close, method: :put do
    resource.close!
    redirect_to resource_path, notice: 'Closed!'
  end

  form title: 'New Debate' do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.input :topic
    f.actions
  end
end
