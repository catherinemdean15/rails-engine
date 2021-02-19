# frozen_string_literal: true

class MerchantItemsSoldSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :count
end
