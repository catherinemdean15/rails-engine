# frozen_string_literal: true

class UnshippedOrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :potential_revenue
end
