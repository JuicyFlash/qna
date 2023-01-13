FactoryBot.define do
  factory :link do
    name { "MyUrl" }
    url { "https://www.google.ru/" }
  end
  trait :invalid do
    name { "MyUrl" }
    url { "MyString" }
  end
end
