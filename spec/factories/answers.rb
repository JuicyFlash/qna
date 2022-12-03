FactoryBot.define do
  factory :answer do
    association :question
    body { "MyString" }
  end
end
