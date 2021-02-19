FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { '01/33' }
    result { %i[complete rejected].sample }
  end
end
