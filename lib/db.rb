# class Store
#   require 'sequel'

#   attr_reader :connection
#   def initialize
#     @connection = Sequel.connect('postgres://vladiim@localhost/property')
#     # createdb property -O vladiim
#     # -W dwnwEaQ5Z
#   end

#   def create_properties_table
#     connection.create_table(:properties) do |p|
#       primary_key :id
#       String :address
#       Integer :price
#       Date :date_sold
#       String :type
#       Integer :bedrooms
#       Integer :bathrooms
#       Integer :carspace
#       String :suburb
#       String :state
#       Integer :landsize
#     end
#   end
# end