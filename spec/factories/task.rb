FactoryBot.define do
  factory :task do
    project
    sequence(:name) { |n| "Task #{n}" }
    status 'new'
  end
end