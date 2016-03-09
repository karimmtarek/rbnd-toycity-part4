require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  brands = []
  product_names = []
  prices = []

  5.times do
    brands << Faker::Commerce.department
    product_names << Faker::Commerce.product_name
    prices << Faker::Commerce.price
  end

  10.times do
    Product.create(
        brand: brands.sample,
        name: product_names.sample,
        price: prices.sample
      )
  end
end
