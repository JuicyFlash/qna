require 'rails_helper'

RSpec.describe NotifyAuthorOfQuestionJob, type: :job do
  let(:answer) { create :answer }
  let(:service) { double('Service::Notify') }

  before do
    allow(Notify).to receive(:new).and_return(service)
  end
  it 'calls Service::Notify#notify_author_of_question' do
    expect(service).to receive(:notify_author_of_question)
    NotifyAuthorOfQuestionJob.perform_now(answer)
  end
end
