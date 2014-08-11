require 'sequel'

# to create db, install postgres then
# `createdb prop -O vlad` in terminal

class Store

  attr_reader :connection
  def initialize
    @connection = connect_to_db
  end

  def save_property_sale(data)
    property_id = connection[:properties].insert(data.fetch(:property))
    sale_data   = data.fetch(:sale).merge(property_id: property_id)
    connection[:sales].insert(sale_data)
  end

  def create_properties_table
    connection.create_table(:properties) do
      primary_key :id
      String :address
      String :type
      Integer :bedrooms
      Integer :bathrooms
      Integer :carspace
      String :suburb
      String :state
      Integer :landsize
    end
  end

  def create_sales_table
    connection.create_table(:sales) do
      foreign_key :property_id, :properties
      primary_key :id
      Integer :price
      Date :date_sold
    end
  end

  private

  def connect_to_db
    Sequel.connect('postgres://vlad@localhost/prop')
  end
end