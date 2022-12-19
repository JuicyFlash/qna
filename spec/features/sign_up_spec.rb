require 'rails_helper'

feature 'User can sign up' do

  given(:user) { create(:user) }

  background do
    visit new_user_registration_path
  end

  describe 'with correct params' do
    scenario 'tries sign up' do
      fill_in 'Email', with: "unregistered_#{user.email}"
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries sign up if already registered' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end

  describe 'with incorrect params' do
    scenario 'tries sign up with blank email' do
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
    end

    scenario 'tries sign up with blank password' do
      fill_in 'Email', with: "unregistered_#{user.email}"
      click_on 'Sign up'

      expect(page).to have_content "Password can't be blank"
    end

    scenario 'tries sign up if password less then 6 characters' do
      fill_in 'Email', with: "unregistered_#{user.email}"
      fill_in 'Password', with: '12345'
      fill_in 'Password confirmation', with: '12345'
      click_on 'Sign up'

      expect(page).to have_content "Password is too short (minimum is 6 characters)"
    end

    scenario 'tries sign up if password different with password confirmation' do
      fill_in 'Email', with: "unregistered_#{user.email}"
      fill_in 'Password', with: '1234567'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
