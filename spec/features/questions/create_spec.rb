require 'rails_helper'

feature 'User can create question', '
  In order to get answer from a community
  As an authenticated user
  I`d like to be able to ask the question
' do

  given(:user) { create(:user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask'
    end

    scenario 'ask a question' do
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text some tex some tex'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'some text some tex some tex'
    end

    scenario 'ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'ask a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text some tex some tex'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  scenario 'Unauthenticated user ask a question' do
    visit questions_path
    click_on 'Ask'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
  describe "multiple sessions" do
    scenario 'question appears on another question`s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'some text some tex some tex'
        click_on 'Ask'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
