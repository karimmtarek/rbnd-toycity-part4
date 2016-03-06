require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  DATA_PATH = File.dirname(__FILE__) + "/../data/data.csv"

  def self.all
    CSV.read(DATA_PATH).drop(1)
  end

  def self.first(records = nil)
    if records
      data = CSV.read(DATA_PATH).drop(1).slice(0..records - 1)
      requested_records = []
      data.each do |record|
        requested_records << new(
          id: record[0],
          brand: record[1],
          name: record[2],
          price: record[3]
        )
      end
      requested_records
    else
      row = CSV.read(DATA_PATH).drop(1).first
      new(id: row[0], brand: row[1], name: row[2], price: row[3])
    end
  end

  def self.last(records = nil)
    if records
      data = CSV.read(DATA_PATH).drop(1).reverse.slice(0..records - 1)
      requested_records = []
      data.each do |record|
        requested_records << new(
          id: record[0],
          brand: record[1],
          name: record[2],
          price: record[3]
        )
      end
      requested_records
    else
      row = CSV.read(DATA_PATH).drop(1).last
      new(id: row[0], brand: row[1], name: row[2], price: row[3])
    end
  end

  def self.create(attributes = nil)
    # If the object's data is already in the database
    # create the object
    # return the object

    # If the object's data is not in the database
    # create the object
    new_recored = new(attributes)

    # save the data in the database
    data_file = CSV.read(DATA_PATH)
    data_file << [new_recored.id, new_recored.brand, new_recored.name, new_recored.price]

    CSV.open(DATA_PATH, 'w') do |csv|
      data_file.each { |row| csv << row }
    end

    # return the object
    new_recored
  end
end
