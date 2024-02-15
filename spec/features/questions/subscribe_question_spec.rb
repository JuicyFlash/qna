require 'rails_helper'

feature 'User can subscribe and unsubscribe to the question' do
  given!(:user) { create(:user) }
  given!(:any_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    scenario 'Subscribe author on question after create question', js: true do
      sign_in(user)
      visit question_path(question)
      within '.subscription' do
       expect(page).to have_link 'Unsubscribe'
       click_on 'Unsubscribe'
       expect(page).to_not have_link 'Unsubscribe'
       expect(page).to have_link 'Subscribe'
      end
    end
    scenario 'Subscribe any user on question', js: true do
      sign_in(any_user)
      visit question_path(question)
      within '.subscription' do
        expect(page).to have_link 'Subscribe'
        click_on 'Subscribe'
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end

  scenario 'unauthenticated user try subscribe to question', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
  end
end
