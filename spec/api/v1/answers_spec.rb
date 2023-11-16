require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {'CONTENT_TYPE' => 'application/json',
                   'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    context 'unauthorized' do
      let!(:question) { create(:question) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let(:user) { create(:user) }
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'return list of questions' do
        expect(json['answers'].size).to eq 2
      end
      it 'returns all public fields' do
        %w[id body created_at updated_at author_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
      it 'contains user object' do
        expect(answer_response['author_id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    context 'unauthorized' do
      let!(:answer) { create(:answer) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let!(:user) { create(:user) }
      let!(:answer) { create(:answer) }
      let!(:comments) { create_list(:comment_on_answer, 3, author: user, commentable: answer) }
      let!(:links) { create_list(:link_on_answer, 3, linkable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
      it 'contains links, comments, files' do
        %w[links comments files].each do |attr|
          expect(answer_response.keys).to include attr
        end
      end

      describe 'comments' do
        let(:comments_response) { answer_response['comments'] }

        it 'return list of comments' do
          expect(comments_response.size).to eq 3
        end
        it 'include comments' do
          expect(comments_response).to eq comments.as_json
        end
      end

      describe 'links' do
        let(:links_response) { answer_response['links'] }

        it 'return list of links' do
          expect(links_response.size).to eq 3
        end
        it 'include links' do
          expect(links_response).to eq links.as_json
        end
      end
    end
  end
end
