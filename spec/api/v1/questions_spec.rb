require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                    'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do

    it_behaves_like 'API authorizable' do
      let(:method) { 'get' }
      let(:api_path) { '/api/v1/questions' }
      let(:params) { { access_token: '1234' } }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }

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

    it_behaves_like 'API authorizable' do
      let(:question) { create(:question) }
      let(:method) { 'get' }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:params) { { access_token: '1234' } }
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

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API authorizable' do
      let(:question) { create(:question) }
      let(:method) { 'post' }
      let(:api_path) { "/api/v1/questions/" }
      let(:params) do { access_token: '1234',
                        question: { body: 'test', title: 'test', user_id: '1' } }
        end
      end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { create(:user) }
      let!(:question) { user.questions.new(title: 'TestQuestionApiCreate', body: 'TestBody') }
      let!(:links) do
        { 0 => { name: 'youtube', url: 'https://www.youtube.com/' },
          1 => { name: 'google', url: 'https://www.google.ru/' } }
      end
      let (:create_request) do
        post '/api/v1/questions', params: { access_token: access_token.token,
                                            user_id: question.author_id,
                                            question: { body: question.body, title: question.title, links_attributes: links } },
                                  headers: headers
      end
      let(:saved_question) { Question.first }

      it 'return 200 status' do
        create_request

        expect(response.status).to eq 200
      end
      it 'save new question' do
        expect(Question.count).to eq 0
        create_request

        expect(Question.count).to eq 1
      end
      it 'save all question links' do
        expect(Link.count).to eq 0
        create_request

        expect(saved_question.links.count).to eq 2
      end
      it 'save all links fields' do
        create_request

        saved_question.links.each do |link|
          expect(links.values).to include name: link.name, url: link.url
        end
      end
      it 'contains all fields' do
        create_request

        %w[title body author_id].each do |attr|
          expect(question.send(attr)).to eq saved_question.send(attr)
        end
      end
    end
   end

  describe 'PATCH /api/v1/questions/:id' do
    it_behaves_like 'API authorizable' do
      let(:question) { create(:question) }
      let(:method) { 'patch' }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:params) do { access_token: '1234',
                        user_id: '1',
                        question: { body: 'test',
                                    title: 'test' } }
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { create(:user) }
      let!(:saved_question) { create(:question, author: user) }
      let!(:question) { user.questions.new(title: 'Updated_TestQuestionApi', body: 'Updated_TestBodyApi') }
      let(:update_request) do
        patch "/api/v1/questions/#{saved_question.id}", params: { access_token: access_token.token,
                                                                  user_id: question.author_id,
                                                                  question: { body: question.body, title: question.title } },
                                                        headers: headers
      end
      let(:updated_question) { Question.find(saved_question.id) }

      it 'return 200 status' do
        update_request

        expect(response.status).to eq 200
      end
      it 'not save(create) new question' do
        expect(Question.count).to eq 1
        update_request

        expect(Question.count).to eq 1
      end
      it 'update question fields' do
        update_request

        %w[title body].each do |attr|
          expect(question.send(attr)).to eq updated_question.send(attr)
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    it_behaves_like 'API authorizable' do
      let(:question) { create(:question) }
      let(:method) { 'delete' }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:params) do { access_token: '1234',
                        user_id: '1' }
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }
      let(:delete_request) do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token,
                                                             user_id: question.author_id }
      end

      it 'return 200 status' do
        delete_request

        expect(response.status).to eq 200
      end
      it 'delete question' do
        expect(Question.count).to eq 1
        delete_request

        expect(Question.count).to eq 0
      end
    end
  end
end
