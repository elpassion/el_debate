ActiveAdmin.register Debate do
  permit_params :topic

  index do
    selectable_column
    id_column
    column :topic
    column :code
    column :created_at
    actions
  end

  show title: proc{|debate| debate.topic } do
    attributes_table do
      row :topic
      row :code
      row :answers do |debate|
        debate.answers.map do |answer|
          link_to answer.value, admin_debate_answer_path(debate, answer.id)
        end.join(', ').html_safe
      end
      row 'All votes' do |debate|
        debate.votes_count
      end

      debate.answers.each do |answer|
        row "Votes for #{answer.value}" do
          answer.votes_count
        end
      end
    end
  end

  form title: 'New Debate' do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.input :topic
    f.actions
  end
end
