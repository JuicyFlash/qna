require 'rails_helper'

feature 'User can edit his question', '
  In order to correct mistakes
  As an author of question
  I`d like to be able to edit my question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question' do
      sign_in(user)
      visit questions_path
      click_on 'Edit'
      fill_in 'Title', with: 'edited question title'
      fill_in 'Body', with: 'edited question body'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to have_content 'edited question title'
    end

    scenario 'edits his question with errors' do
      sign_in(user)
      visit questions_path
      click_on 'Edit'
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user`s question" do
      not_author = create(:user)
      sign_in(not_author)
      visit questions_path
      expect(page).to_not have_link 'Edit'
    end
  end
end
