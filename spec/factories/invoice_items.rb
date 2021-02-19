# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity { [0..100].sample }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end
