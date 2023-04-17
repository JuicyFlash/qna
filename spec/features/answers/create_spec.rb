require 'rails_helper'

feature 'User can answer to a question', '
  User can answer to a question from the question page
' do
  given(:user) { create(:user) }

  given!(:question) { create(:question, author: user, best_answer: nil) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer to a question', js: true do

      fill_in 'Body', with: 'some answer'
      click_on 'Answer'

      expect(page).to have_content 'some answer'
    end

    scenario 'answer to a question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer with attached file', js: true do
      fill_in 'Body', with: 'some text some tex some tex'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  scenario 'Unauthenticated user answer to a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
  describe "multiple sessions" do
    scenario 'answer appears on another answer`s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'some answer'
        click_on 'Answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'some answer'
      end
    end
  end
end
