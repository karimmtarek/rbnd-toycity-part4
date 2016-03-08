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
    brands_count = {}
    brands = products.map(&:brand).uniq

    brands.each do |brand|
      brands_count[brand] = products.select { |p| p.brand == brand }.size
    end

    brands_count
  end

  def self.count_by_name(products)
    name_count = {}
    names = products.map(&:name).uniq

    names.each do |name|
      name_count[name] = products.select { |p| p.name == name }.size
    end

    name_count
  end
end
