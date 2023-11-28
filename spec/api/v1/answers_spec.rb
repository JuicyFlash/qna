require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { {'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
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

  describe 'POST /api/v1/questions/:question_id/answers' do
    context 'unauthorized' do
      let!(:question) { create(:question) }

      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers"
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { access_token: '1234',
                                                                   user_id: '1',
                                                                   answer: { body: 'test' } }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:answer) { question.answers.new(body: 'TestAnswerBody', author: user) }
      let!(:links) do
        { 0 => { name: "youtube", url: "https://www.youtube.com/" },
          1 => { name: "google", url: "https://www.google.ru/" } }
      end
      let (:create_request) do
        post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                   user_id: answer.author_id,
                                                                   answer: { body: answer.body, links_attributes: links } },
             headers: headers
      end
      let(:saved_answer) { Answer.first }

      it 'return 200 status' do
        create_request

        expect(response.status).to eq 200
      end
      it 'save new question' do
        expect { create_request }.to change(question.answers, :count).by(1)
      end
      it 'save all question links' do
        expect(Link.count).to eq 0
        create_request

        expect(saved_answer.links.count).to eq 2
      end
      it 'save all links fields' do
        create_request

        saved_answer.links.each do |link|
          expect(links.values).to include name: link.name, url: link.url
        end
      end
      it 'contains all fields' do
        create_request

        %w[body author_id question_id].each do |attr|
          expect(answer.send(attr)).to eq saved_answer.send(attr)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    context 'unauthorized' do
      let!(:answer) { create(:answer) }

      it 'returns 401 status if there is no access_token' do
        patch "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        patch "/api/v1/answers/#{answer.id}", params: { access_token: '1234',
                                                        user_id: '1',
                                                        answer: { body: 'test' } }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:saved_answer) { create(:answer, author: user, question: question) }
      let!(:answer) { question.answers.new(body: 'Updated_TestBody', author: user) }
      let(:update_request) do
        patch "/api/v1/answers/#{saved_answer.id}", params: { access_token: access_token.token,
                                                              user_id: answer.author_id,
                                                              answer: { body: answer.body } },
              headers: headers
      end
      let(:updated_answer) { Answer.find(saved_answer.id) }

      it 'return 200 status' do
        update_request

        expect(response.status).to eq 200
      end
      it 'not save(create) new answer' do
        expect(Question.count).to eq 1
        update_request

        expect(Question.count).to eq 1
      end
      it 'update answer fields' do
        update_request

        %w[body].each do |attr|
          expect(answer.send(attr)).to eq updated_answer.send(attr)
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    context 'unauthorized' do
      let!(:answer) { create(:answer) }

      it 'returns 401 status if there is no access_token' do
        delete "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if there is invalid' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: '1234',
                                                         user_id: '1' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, author: user, question: question) }
      let(:delete_request) do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token,
                                                         user_id: answer.author_id }
      end

      it 'return 200 status' do
        delete_request

        expect(response.status).to eq 200
      end
      it 'delete answer' do
        expect(question.answers.count).to eq 1
        delete_request

        expect(question.answers.count).to eq 0
      end
    end
  end
end
