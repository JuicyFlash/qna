require 'rails_helper'

feature 'User can mark the best answer', '
  Only the author of question can mark best answer
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    scenario 'mark answer and he is author of this question', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Best'
      end
      within '.best-answer' do
        expect(page).to have_content answer.body
      end
    end
    scenario 'try mark answer and he isn`t author of this question', js: true do
      not_author = create(:user)
      sign_in(not_author)
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Best'
      end
    end
  end
  scenario 'unauthenticated user try mark answer', js: true do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Best'
    end
  end
end
