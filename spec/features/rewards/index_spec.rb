require 'rails_helper'

feature 'User can view rewards received by him' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:reward) { create(:reward, question: question) }

  describe 'Authenticated user' do
    scenario 'view rewards', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Best'
      end
      visit rewards_path
      expect(page).to have_content question.title
      expect(page).to have_content reward.name
    end
  end
  describe 'Unauthenticated user view rewards' do
    scenario ' view rewards' do
      visit rewards_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
