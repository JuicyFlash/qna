require 'rails_helper'

feature 'User can add links to answer', '
  In order to provide additional info to my answer
  As an answer author
  I`d like to be able to add links
' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/JuicyFlash/33c85a488910031155b2da32ed3af130' }
  given!(:question) { create(:question, author: user, best_answer: nil) }

  scenario 'User adds link when answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'my answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end