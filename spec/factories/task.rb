# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    project
    sequence(:name) { |n| "Task #{n}" }
    status 'new task'
  end
end