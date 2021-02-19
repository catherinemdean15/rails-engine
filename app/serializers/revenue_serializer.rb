# frozen_string_literal: true

class RevenueSerializer
  class << self
    def revenue_by_date(revenue)
      { data: {
        id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        }
      } }
    end

    def merchant_revenue(merchant, revenue)
      { data: {
        id: merchant.id.to_s,
        type: 'merchant_revenue',
        attributes: {
          revenue: revenue
        }
      } }
    end
  end
end
