class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.references :debate, index: true
      t.string :value
      t.integer :answer_type
    end
  end
end
