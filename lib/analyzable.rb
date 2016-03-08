module Analyzable
  def self.average_price(products)
    (products.map { |p| p.price.to_f }.reduce(:+) / products.size).round(2)
  end

  def self.count_by_brand(products)
    brands_count = {}
    brands = products.map(&:brand).uniq

    brands.each do |brand|
      brands_count[brand] = products.select(&:brand).size
    end

    brands_count
  end
end
