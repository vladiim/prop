# require Dir.pwd + '/scraper'

class Property
	attr_accessor :address, :price, :type, :bedrooms, 
	              :bathrooms, :carspace, :landsize, :date_sold,
	              :rent, :date_rented
end

require "mechanize"
agent = Mechanize.new
agent.get("http://house.ksou.cn/p.php?q=Marrickville&s=1&region=Marrickville&sta=nsw")
main = agent.page.search("table#mainT")
table = main.search("table")
property = table.search("tr td[2] table")

def add_meta_data(meta_text, prop, type)
  prop.type = type
  prop.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-8...-7]
  prop.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
  prop.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
end

property.each do |prop_mech|
  prop_obj = Property.new

  address  = prop_mech.search("span.addr").text
  next if address == ""
  prop_obj.address = address

  price = prop_mech.search("b").text.match(/\d+(?:\,\d+)(?:\,\d+)?/)[0].gsub(",", "").to_i
  prop_obj.price = price

  date_sold_str = prop_mech.search("tr[1] > td[1]").text.match(/\w+ \d{4}/)[0]
  date_sold = Date.strptime(date_sold_str, "%b %Y")
  prop_obj.date_sold = date_sold

  meta_text = prop_mech.search("tr[2] > td").text

  case meta_text
    when /Unit: /
    	add_meta_data(meta_text, prop_obj, "Unit")
  	 #  prop_obj.type = type
		  # prop_obj.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
		  # prop_obj.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
		  # prop_obj.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
  	when /Apartment: /
    	add_meta_data(meta_text, prop_obj, "Apartment")
    # 	type = "Apartment"
  	 #  prop_obj.type = type
		  # prop_obj.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
		  # prop_obj.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
		  # prop_obj.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
  	when /House: /
    	add_meta_data(meta_text, prop_obj, "House")
    # 	type = "House"
  	 #  prop_obj.type = type
		  # prop_obj.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
		  # prop_obj.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
		  # prop_obj.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
  	when /Townhouse: /
    	add_meta_data(meta_text, prop_obj, "Townhouse")
    # 	type = "Townhouse"
  	 #  prop_obj.type = type
		  # prop_obj.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
		  # prop_obj.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
		  # prop_obj.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
  	when /Terrace: /
    	add_meta_data(meta_text, prop_obj, "Terrace")
    # 	type = "Terrace"
  	 #  prop_obj.type = type
		  # prop_obj.bedrooms  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
		  # prop_obj.bathrooms = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-5...-4]
		  # prop_obj.carspace  = meta_text.match(/#{type}: ?(\d\s+)+/)[0][-2...-1]
		else
			prop_obj.type = "Unknown"
  end

  p prop_obj
end