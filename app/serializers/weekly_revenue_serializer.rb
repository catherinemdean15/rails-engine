class WeeklyRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue

  attribute :week do |week_as_date|
    week_as_date.week.to_date
  end
end
