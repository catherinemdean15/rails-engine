# frozen_string_literal: true

class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :revenue
end
