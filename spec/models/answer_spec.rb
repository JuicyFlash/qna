require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of(:body) }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
