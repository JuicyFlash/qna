require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }

  let(:question) { create(:question, author: user) }
  let(:answer){ create(:answer, question: question, author: user) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    let(:question) do
      create(:question, author: user) do |question|
        create_list(:answer, 3, question: question, author: user)
      end
    end

    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end
    it 'populates an array of all question`s answers' do
      expect(assigns(:answers)).to match_array(question.answers)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }
    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end
    it 'assign a new @question.answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do

      let(:answer) { create(:answer, question: question, author: user) }
      it '@question is a parent @answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).question).to eq(question)
      end
      it 'save a new answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
      end
    end
    context 'with invalid attributes' do
      it 'does not save new answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do

    let!(:question) do
      create(:question, author: user) do |question|
        create(:answer, question: question, author: user)
      end
    end

    it 'not delete if user is not author of @answer' do
      not_author = create(:user)
      login(not_author)
      expect { delete :destroy, params: { id: question.answers[0] }, format: :js}.to change(Answer, :count).by(0)
    end

    it 'delete the answer' do
      login(user)
      expect { delete :destroy, params: { id: question.answers[0] }, format: :js }.to change(Answer, :count).by(-1)
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    context 'with valid attributes' do
      it 'change answer attributes' do
        login(user)
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'renders update view' do
        login(user)
        patch :update, { params: { id: answer, answer: { body: 'new body' } }, format: :js }
        expect(response).to render_template :update
      end
    end
    context 'with invalid attributes' do
      it 'does not change answer attribute' do
        expect do
          patch :update, { params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }
        end.to_not change(answer, :body)
      end
      it 'renders update view' do
        login(user)
        patch :update, { params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }
        expect(response).to render_template :update
      end
    end
  end
end
