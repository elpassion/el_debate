require 'rails_helper'

feature 'Debates management' do
  given(:admin_user) { create(:admin_user) }
  given(:debate_without_code) do
    debate = create(:debate)
    debate.update_column(:code, nil)
    debate
  end

  background { login_as(admin_user) }

  scenario 'allow user to generate code if it is missing' do
    visit admin_debate_path(debate_without_code)
    within 'tr.row-code' do
      click_link_or_button 'Generate code'
    end

    within 'tr.row-code' do
      expect(page).to have_content(debate_without_code.reload.code)
    end
  end
end
