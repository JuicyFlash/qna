module OmniauthMacros
  def mock_auth_github_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  'provider' => 'github',
                                                                  'uid' => '123545',
                                                                  'info' => {
                                                                    'nickname' => 'mock_github_user',
                                                                    'name' => 'mock_github_user',
                                                                    'email' => 'test@gmail.com'
                                                                  },
                                                                  'credentials' => {
                                                                    'token' => 'github_token'
                                                                  }
                                                                })
  end

  def mock_auth_google_hash
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                         'provider' => 'google_oauth2',
                                                                         'uid' => '123545',
                                                                         'info' => {
                                                                           'name' => 'mock_google_user',
                                                                           'email' => 'test@gmail.com'
                                                                         },
                                                                         'credentials' => {
                                                                           'token' => 'google_token'
                                                                         }
                                                                       })
    end
end
