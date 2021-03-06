module Analyzable
  def print_report(products)
    puts "Average Price: $#{average_price(products)}"
    puts "Inventory by Brand:"
    count_by_brand(products).each do |key, value|
      puts " - #{key}: #{value}"
    end

    puts "Inventory by Name:"
    count_by_name(products).each do |key, value|
      puts " - #{key}: #{value}"
    end
    ""
  end

  def self.average_price(products)
    (products.map { |p| p.price.to_f }.reduce(:+) / products.size).round(2)
  end

  def self.count_by_brand(products)
    products.map(&:brand).uniq.inject({}) do |brands_count, brand|
      brands_count.merge(brand => products.select { |p| p.brand == brand }.size)
    end
  end

  def self.count_by_name(products)
    products.map(&:name).uniq.inject({}) do |name_count, name|
      name_count.merge(name => products.select { |p| p.name == name }.size)
    end
  end
end
