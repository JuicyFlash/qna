require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) do
    create(:question) do |question|
      create(:answer, question: question)
    end
  end

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    let(:question) do
      create(:question) do |question|
        create_list(:answer, 3, question: question)
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
    context 'with valid attributes' do
      it '@question is a parent @answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).question).to eq(question)
      end
      it 'save a new answer in database' do
        question = create(:question)
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end
      it 'redirect to index view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_answers_path
      end
    end
    context 'with invalid attributes' do
      it 'does not save new answer' do
        question = create(:question)
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
