class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :count
end
