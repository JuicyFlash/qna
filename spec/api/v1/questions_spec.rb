require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {'CONTENT_TYPE' => 'application/json',
                   'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end
      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end
      it 'contains short_title' do
        expect(question_response['short_title']).to eq question.title.truncate(4)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end
        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    context 'unauthorized' do
      let!(:question) { create(:question) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:comments) { create_list(:comment_on_question, 3, author: user, commentable: question) }
      let!(:links) { create_list(:link_on_question, 3, linkable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end
      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
      it 'contains links, comments, files' do
        %w[links comments files].each do |attr|
          expect(question_response.keys).to include attr
        end
      end

      describe 'comments' do
        let(:comments_response) { question_response['comments'] }

        it 'return list of comments' do
          expect(comments_response.size).to eq 3
        end
        it 'include comments' do
          expect(comments_response).to eq comments.as_json
        end
      end

      describe 'links' do
        let(:links_response) { question_response['links'] }

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
