require 'rails_helper'

feature 'User can sig in wit Github and Google' do
  describe "Github" do
      it "can sign in with GitHub account", js: true do
        visit new_user_registration_path
        expect(page).to have_content("Sign in with GitHub")
        mock_auth_github_hash
        click_on "Sign in with GitHub"
        expect(page).to have_content("Successfully authenticated from Github account")
        expect(page).to have_content("Sign out")
      end
    end
  describe "Google" do
    it "can sign in with Google account", js: true do
      visit new_user_registration_path
      expect(page).to have_content("Sign in with GoogleOauth2")
      mock_auth_google_hash
      click_on "Sign in with GoogleOauth2"
      expect(page).to have_content("Successfully authenticated from Google account")
      expect(page).to have_content("Sign out")
    end
  end
end
