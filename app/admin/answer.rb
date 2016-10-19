ActiveAdmin.register Answer do
  belongs_to :debate

  config.clear_action_items!

  action_item :back, only: :show do
    link_to 'Back', admin_debate_path(answer.debate)
  end

  show do
    attributes_table do
      row :value
      row :answer_type_key
    end
  end
end
