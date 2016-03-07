require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  DATA_PATH = File.dirname(__FILE__) + "/../data/data.csv"
  DATA_HEADER = {
    id: 0,
    brand: 1,
    name: 2,
    price: 3
  }

  DATA_HEADER.keys.each do |key|
    attr_writer key.to_sym
  end

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

  def self.find(record_id)
    record = CSV.read(DATA_PATH).drop(1)[record_id - 1]
    new(
      id: record[0],
      brand: record[1],
      name: record[2],
      price: record[3]
    )
  end

  def self.where(statement)
    records = CSV.read(DATA_PATH).drop(1)
    selected = records.select do |record|
      record[DATA_HEADER[statement.keys.first]] == statement.values.first
    end
    requested_records = []
    selected.each do |record|
      requested_records << new(
        id: record[0],
        brand: record[1],
        name: record[2],
        price: record[3]
      )
    end
    requested_records
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

  def update(params)
    data_file = CSV.read(DATA_PATH)

    data_file.each do |record|
      next unless record[0] == id.to_s
      params.each do |k, v|
        record[DATA_HEADER[k]] = v
      end
      self.brand = record[1]
      self.name = record[2]
      self.price = record[3]
    end

    CSV.open(DATA_PATH, 'w') do |csv|
      data_file.each { |row| csv << row }
    end

    self
  end

  def self.destroy(record_id)
    data_file = CSV.read(DATA_PATH)
    deleted_record = data_file.delete_at(record_id)
    CSV.open(DATA_PATH, 'w') do |csv|
      data_file.each { |row| csv << row }
    end
    new(
      id: deleted_record[0],
      brand: deleted_record[1],
      name: deleted_record[2],
      price: deleted_record[3]
    )
  end
end
