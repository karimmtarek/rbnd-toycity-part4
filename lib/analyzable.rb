module Analyzable
  def self.average_price(products)
    (products.map { |p| p.price.to_f }.reduce(:+) / products.size).round(2)
  end
end
