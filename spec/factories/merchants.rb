# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { Faker::IndustrySegments.industry }
  end
end
