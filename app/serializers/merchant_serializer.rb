# frozen_string_literal: true

class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
end
