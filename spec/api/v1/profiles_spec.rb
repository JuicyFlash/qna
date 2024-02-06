require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { 
    {'CONTENT_TYPE' => 'application/json',
                   'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API authorizable' do
      let(:method) { 'get' }
      let(:api_path) { '/api/v1/profiles/me' }
      let(:params) do
        { access_token: '1234' }
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end
      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/all' do
    it_behaves_like 'API authorizable' do
      let(:method) { 'get' }
      let(:api_path) { '/api/v1/profiles/all' }
      let(:params) do
        { access_token: '1234' }
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:profile_response) { json['users'].first }
      let(:profiles_response) { json['users'] }
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }

      before { get '/api/v1/profiles/all', params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'returns all unauthorized users' do
        expect(profiles_response).to include(user1.as_json, user2.as_json)
        expect(profiles_response.size).to eq 2
      end
      it 'does not return authorized user' do
        expect(profiles_response).to_not include(me.as_json)
      end
      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(profile_response).to_not have_key(attr)
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
