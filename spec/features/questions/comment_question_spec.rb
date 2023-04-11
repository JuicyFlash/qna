require 'rails_helper'

feature 'User can add comments to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }

  scenario 'add new comment to question', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Comments'
    fill_in 'Body', with: 'some comment'
    click_on 'Comment'
    expect(page).to have_content 'some comment'
  end
  scenario 'comments appears on another question`s page', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('guest') do
      visit questions_path
      click_on 'Comments'
    end

    Capybara.using_session('user') do
      click_on 'Comments'
      fill_in 'Body', with: 'some comment'
      click_on 'Comment'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'some comment'
    end
  end
end
