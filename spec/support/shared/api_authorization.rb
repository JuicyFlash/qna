shared_examples_for 'API authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'returns 401 status if there is invalid' do
      do_request(method, api_path, params: params, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
