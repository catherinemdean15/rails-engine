FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { ["processing", "shipped", "cancelled"].sample }
  end
end
