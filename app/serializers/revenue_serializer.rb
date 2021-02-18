class RevenueSerializer
  class << self
    def revenue_by_date(revenue)
      {
        data: {
          id: nil,
          type: 'revenue',
          attributes: {
            revenue: revenue
          }
        }
      }
    end
  end
end
