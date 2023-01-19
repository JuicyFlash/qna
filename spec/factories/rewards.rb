FactoryBot.define do
  factory :reward do
    association :question

      name { "MyRevard" }
  end
end
