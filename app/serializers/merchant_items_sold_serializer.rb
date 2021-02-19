class MerchantItemsSoldSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :count
end
