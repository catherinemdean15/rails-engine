class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :revenue
end
