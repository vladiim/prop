# require Dir.pwd + '/scraper'

class Scraper
  require "mechanize"

  attr_reader :agent, :properties
  def initialize(uri)
    @agent = Mechanize.new
    @properties = []
    agent.get(uri)
  end

  def extract_data(property_klass = Property)
    raw_contents = agent.page.search("table#mainT table tr td[2] table")

    raw_contents.each do |raw_content|
      property = property_klass.new(raw_content)
      properties << property if property.valid?
    end
  end
end

class Property

  attr_reader :raw_content, :is_property
  def initialize(raw_content)
    @raw_content = raw_content
    begin
      find_and_save_data
      @is_property = true
    rescue Exception
      @is_property = false
    end
  end

  def valid?
    is_property
  end

  attr_reader :address, :price, :date_sold
  attr_reader :type, :bedrooms, :bathrooms, :carspace
  private

  def find_and_save_data
    @address   = raw_content.search("span.addr").text
    @price     = raw_content.search("b").text.match(/\d+(?:\,\d+)(?:\,\d+)?/)[0].gsub(",", "").to_i
    date_sold  = raw_content.search("tr[1] > td[1]").text.match(/\w+ \d{4}/)[0]
    @date_sold = Date.strptime(date_sold, "%b %Y")
    find_and_save_meta_data
  end

  def find_and_save_meta_data
    meta_content = raw_content.search("tr[2] > td").text
    case meta_content
      when /Unit: /;      save_meta_data(meta_content, "Unit")
      when /Apartment: /; save_meta_data(meta_content, "Apartment")
      when /House: /;     save_meta_data(meta_content, "House")
      when /Townhouse: /; save_meta_data(meta_content, "Townhouse")
      when /Terrace: /;   save_meta_data(meta_content, "Terrace")
      else;               save_meta_data(meta_content, "Unknown")
    end
  end

  def save_meta_data(meta_content, type)
    @type      = type
    @bedrooms  = meta_content.match(/#{type}: ?(\d\s+)+/)[0][-8...-7].to_i
    @bathrooms = meta_content.match(/#{type}: ?(\d\s+)+/)[0][-5...-4].to_i
    @carspace  = meta_content.match(/#{type}: ?(\d\s+)+/)[0][-2...-1].to_i
  end
end

# class Property
#   attr_accessor :address, :price, :type, :bedrooms, 
#                 :bathrooms, :carspace, :landsize, :date_sold,
#                 :rent, :date_rented
# end

# require "mechanize"
# agent = Mechanize.new
# agent.get("http://house.ksou.cn/p.php?q=Marrickville&s=1&region=Marrickville&sta=nsw")
# main = agent.page.search("table#mainT")
# table = main.search("table")
# property = table.search("tr td[2] table")

# def add_meta_data(meta_text, prop, type)
#   prop.type = type
#   prop.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-8...-7]
#   prop.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
#   prop.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
# end

# property.each do |prop_mech|
#   prop_obj = Property.new

#   address  = prop_mech.search("span.addr").text
#   next if address == ""
#   prop_obj.address = address

#   price = prop_mech.search("b").text.match(/\d+(?:\,\d+)(?:\,\d+)?/)[0].gsub(",", "").to_i
#   prop_obj.price = price

#   date_sold_str = prop_mech.search("tr[1] > td[1]").text.match(/\w+ \d{4}/)[0]
#   date_sold = Date.strptime(date_sold_str, "%b %Y")
#   prop_obj.date_sold = date_sold

#   meta_text = prop_mech.search("tr[2] > td").text

#   case meta_text
#     when /Unit: /
#       add_meta_data(meta_text, prop_obj, "Unit")
#     when /Apartment: /
#       add_meta_data(meta_text, prop_obj, "Apartment")
#     when /House: /
#       add_meta_data(meta_text, prop_obj, "House")
#     when /Townhouse: /
#       add_meta_data(meta_text, prop_obj, "Townhouse")
#     when /Terrace: /
#       add_meta_data(meta_text, prop_obj, "Terrace")
#     else
#       prop_obj.type = "Unknown"
#   end

#   p prop_obj
# end