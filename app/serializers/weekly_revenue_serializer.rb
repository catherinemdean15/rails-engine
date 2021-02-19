class WeeklyRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :week, :revenue
end
