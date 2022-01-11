FactoryBot.define do
  factory :meeting do
    title { Faker::FunnyName.two_word_name }
    start_time { Faker::Date.between(from: 2.days.ago, to: 1.day.ago) }
    end_time { Faker::Date.between(from: 1.day.ago, to: Date.today) }
    is_private { false }
  end
end
