require 'rails_helper'

feature 'User can edit his question', '
  In order to correct mistakes
  As an author of question
  I`d like to be able to edit my question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }

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
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to have_content 'edited question title'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'delete question`s` file' do
      sign_in(user)
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb", content_type: "text")
      visit questions_path
      click_on 'Edit'
      click_on 'Delete file'
      expect(page).to_not have_content 'rails_helper.rb'
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
