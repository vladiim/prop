class Property

  attr_reader :raw_content, :suburb, :state
  def initialize(raw_content, suburb, state)
    @raw_content = raw_content
    @suburb      = suburb
    @state       = state
    try_to_find_data
  end

  def valid?(properties)
    is_property & address != '' & properties.each { |p| p.price != price }
  end

  attr_reader :is_property, :address, :price, :date_sold,
    :type, :bedrooms, :bathrooms, :carspace, :landsize

  private

  def try_to_find_data
    begin
      find_and_save_data
      @is_property = true
    rescue Exception
      @is_property = false
    ensure
      @raw_content = ''
    end
  end

  def find_and_save_data
    @address   = raw_content.search("span.addr").text
    @price     = raw_content.search("b").text.match(/\d+(?:\,\d+)(?:\,\d+)?/)[0].gsub(",", "").to_i
    date_sold  = raw_content.search("tr[1] > td[1]").text.match(/\w+ \d{4}/)[0]
    @date_sold = Date.strptime(date_sold, "%b %Y")
    @landsize  = raw_content.search("tr[3] td[1]").text.match(/\d+/)[0].to_i
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