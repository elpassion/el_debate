require 'rails_helper'

feature 'Closing debate' do
  given(:admin_user) { create(:admin_user) }
  given(:debate)     { create(:debate) }

  background do
    login_as(admin_user)
  end

  scenario 'Closing debate in admin panel' do
    visit admin_debate_path(debate)
    within 'div.title_bar' do
      click_link_or_button 'Close'
    end

    expect(page).to have_selector('div.flash_notice')
    expect(page).to have_content('Debate closed!')

    visit "/dashboard/#{debate.id}"
    within 'p#debate-status' do
      expect(page).to have_content('closed')
    end
  end
end
