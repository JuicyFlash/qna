require 'rails_helper'

feature 'User can vote the question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      visit questions_path
    end
    scenario 'vote question and he is author of this question', js: true do
      sign_in(user)
      within '.votes' do
        expect(page).to_not have_link 'Like'
      end
    end

    scenario 'cancel the vote question ', js: true do
      not_author = create(:user)
      sign_in(not_author)
      click_on 'Like'
      within '.votes' do
        expect(page).to have_content '1'
      end
      click_on 'Unvote'
      within '.votes' do
        expect(page).to have_content '0'
      end
    end

    scenario 'vote question (like) and he isn`t author of this question', js: true do
      not_author = create(:user)
      sign_in(not_author)
      click_on 'Like'
      within '.votes' do
        expect(page).to have_content '1'
      end
    end

    scenario 'vote question (dislike) and he isn`t author of this question', js: true do
      not_author = create(:user)
      sign_in(not_author)
      click_on 'Dislike'
      within '.votes' do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'unauthenticated user try vote question', js: true do
    visit questions_path
    within '.votes' do
      expect(page).to_not have_link 'Like'
    end
  end
end
