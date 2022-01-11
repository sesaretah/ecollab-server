FactoryBot.define do
  factory :event do
    title { Faker::FunnyName.two_word_name }
    start_date { Faker::Date.between(from: 2.days.ago, to: 1.day.ago) }
    end_date { Faker::Date.between(from: 1.day.ago, to: Date.today) }
    is_private { false }
  end
end
