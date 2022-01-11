FactoryBot.define do
  factory :tag do
    title { Faker::FunnyName.two_word_name }
  end
end
