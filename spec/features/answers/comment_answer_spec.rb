require 'rails_helper'

feature 'User can add comments to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'add new comment to answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Comments'
    within '.comments' do
      fill_in 'Body', with: 'some comment'
      click_on 'Comment'
      expect(page).to have_content 'some comment'
    end
  end
  scenario 'comments appears on another answer`s page', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
      click_on 'Comments'
    end

    Capybara.using_session('guest') do
      visit question_path(question)
      click_on 'Comments'
    end

    Capybara.using_session('user') do
      within '.comments' do
        fill_in 'Body', with: 'some comment'
        click_on 'Comment'
      end
    end

    Capybara.using_session('guest') do
      within '.comments' do
        expect(page).to have_content 'some comment'
      end
    end
  end
end
