# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    user
    name 'My first project'
  end
end