# db = Sequel.postgres('property', user: 'vladmeh', password: 'Jr5MK%uFTvmBI1T%', host: 'localhost')

class App
  require 'sequel'

  attr_reader :db
  def initialize
    @db = Sequel.postgres('property', user: 'vladmeh', password: 'Jr5MK%uFTvmBI1T%', host: 'localhost')
  end

  def create_properties_table
    db.create_table(:properties) do |p|
      primary_key :id
      String :address
      Integer :price
      Date :date_sold
      String :type
      Integer :bedrooms
      Integer :bathrooms
      Integer :carspace
      String :suburb
      String :state
    end
  end
end

class Iterator
  URL = "http://house.ksou.cn/p.php?"

  attr_reader :uri, :suburb, :state, :page, :scraper, :properties
  def initialize(suburb, state)
    @suburb     = suburb
    @state      = state
    @page       = -1
    @properties = []
    @uri        = gen_next_page_uri
  end

  def scrape
    scraper = Scraper.new(uri, suburb, state)
    scraper.extract_data
    update_properties(scraper) if scraper.properties.length > 0
  end

  def scrape_next_page
    old_properties_length = properties.length
    @uri = gen_next_page_uri
    scrape
  end

  def scrape_all_pages
    scrape if page == 0
    catch :no_more_properties do
      loop { scrape_next_page }
    end
  end

  private
  def gen_next_page_uri
    @page = page + 1
    URL + "q=#{ suburb }&region=#{ suburb }&sta=#{ state }&p=#{ page }"
  end

  def update_properties(scraper)
    scraper.properties.each { |property| properties << property }
  end
end

class Scraper
  # saves unique property data

  require "mechanize"

  attr_reader :agent, :properties, :suburb, :state
  def initialize(uri, suburb, state)
    @agent      = Mechanize.new
    @suburb     = suburb
    @state      = state
    @properties = []

    begin
      agent.get(uri)
    rescue Mechanize::ResponseCodeError
      throw :no_more_properties
    end
  end

  def extract_data
    raw_contents = agent.page.search("table#mainT table tr td[2] table")

    raw_contents.each do |raw_content|
      property = Property.new(raw_content, suburb, state)
      properties << property if property.valid?
    end
  end
end

class Property

  attr_reader :raw_content, :is_property, :suburb, :state
  def initialize(raw_content, suburb, state)
    @raw_content = raw_content
    @suburb      = suburb
    @state       = state
    begin
      find_and_save_data
      @is_property = true
    rescue Exception
      @is_property = false
    ensure
      @raw_content = ''
    end
  end

  def valid?
    is_property
  end

  attr_reader :address, :price, :date_sold,
    :type, :bedrooms, :bathrooms, :carspace

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