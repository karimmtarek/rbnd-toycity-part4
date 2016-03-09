require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  DATA_PATH = File.dirname(__FILE__) + "/../data/data.csv"

  DATA_HEADER = [:id, :brand, :name, :price]

  DATA_HEADER.each do |attr|
    attr_writer attr
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
    all.select { |record| record.id == record_id }[0]
  end

  def self.where(arg)
    all.select { |record| record.send(arg.keys.first.to_sym) == arg.values.first }
  end

  def self.create(attributes = nil)
    return new(attributes) if attributes[:id] && record_exists?(attributes[:id])

    products = all
    new_recored = new(attributes)
    products << new_recored
    construct_csv_from_objs(products)
    new_recored
  end

  def update(params)
    params.each do |key, value|
      send("#{key}=", value)
    end

    self.class.destroy(id)
    products = self.class.all
    products << self
    self.class.construct_csv_from_objs(products)
    self
  end

  def self.destroy(record_id)
    fail no_recored_error(record_id) unless record_exists?(record_id)

    products = all
    # using find returns an object that is diffrent than the one is in the
    # products array, so this is a work around for now
    record = products.select { |p| p.id == record_id }[0]
    deleted_record = products.delete(record)
    construct_csv_from_objs(products)
    deleted_record
  end

  private

  def self.create_record_obj(record)
    new(id: record[0], brand: record[1], name: record[2], price: record[3])
  end

  def self.record_exists?(id)
    all.each { |record| return true if record.id == id }
    false
  end

  def self.construct_csv_from_objs(objs)
    objs.unshift(["id", "brand", "product", "price"])
    CSV.open(DATA_PATH, 'w') do |csv|
      objs.each do |obj|
        if obj.is_a?(Array)
          csv << obj
        else
          csv << [obj.id, obj.brand, obj.name, obj.price]
        end
      end
    end
  end

  def self.no_recored_error(record_id)
    ProductNotFoundError.new "No record found with id: #{record_id}."
  end
end
