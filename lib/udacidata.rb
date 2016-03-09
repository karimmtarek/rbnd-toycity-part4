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
    CSV
      .read(DATA_PATH)
      .drop(1)
      .map { |record| create_record_obj(record) }
  end

  def self.first(records = nil)
    return all.slice(0..records - 1) if records
    all.first
  end

  def self.last(records = nil)
    return all.reverse.slice(0..records - 1) if records
    all.last
  end

  def self.find(record_id)
    fail no_recored_error(record_id) if record_id > all.length
    all[record_id - 1]
  end

  def self.where(arg)
    all.select { |record| record.send(arg.keys.first.to_sym) == arg.values.first }
  end

  def self.create(attributes = nil)
    return new(attributes) if attributes[:id] && record_exists?(attributes[:id])

    data_file = CSV.read(DATA_PATH)
    new_recored = new(attributes)
    data_file << [new_recored.id, new_recored.brand, new_recored.name, new_recored.price]
    construct_csv(data_file)
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

    construct_csv(data_file)
    self
  end

  def self.destroy(record_id)
    data_file = CSV.read(DATA_PATH)

    fail no_recored_error(record_id) if record_id > data_file.length

    deleted_record = data_file.delete_at(record_id)
    construct_csv(data_file)
    create_record_obj(deleted_record)
  end

  def self.create_record_obj(record)
    new(
        id: record[0],
        brand: record[1],
        name: record[2],
        price: record[3]
      )
  end

  def self.record_exists?(id)
    all.each { |record| return true if record.id == id }
    false
  end

  def self.construct_csv(data_file)
    CSV.open(DATA_PATH, 'w') do |csv|
      data_file.each { |row| csv << row }
    end
  end

  def construct_csv(data_file)
    CSV.open(DATA_PATH, 'w') do |csv|
      data_file.each { |row| csv << row }
    end
  end

  def self.no_recored_error(record_id)
    ProductNotFoundError.new "No record found with id: #{record_id}."
  end
end
