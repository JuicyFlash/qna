require 'rails_helper'

RSpec.describe NotifyQuestionSubscribersJob, type: :job do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:service) { double('Service::Notify') }

  before do
    allow(Notify).to receive(:new).and_return(service)
  end
  it 'calls Service::Notify#notify_question_subscribers' do
    expect(service).to receive(:notify_question_subscribers).with(question)
    NotifyQuestionSubscribersJob.perform_now(answer.question)
  end
end
