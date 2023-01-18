require 'rails_helper'

feature 'User can add rewards to question', '
  In order to rewards best answer`s author of this question
  As an question author
  I`d like to be able to rewards name and rewards picture
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'some text some tex some tex'
    fill_in 'Reward name', with: 'Test rewards'
    attach_file 'Image', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
  end
end
