class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.partial_match(keyword, column)
    where("lower(#{column}) like ?", "%#{keyword.downcase}%")
  end
end
