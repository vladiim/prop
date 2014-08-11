Dir["#{Dir.pwd}/lib/*.rb"].each { |file| require file }

class App
  attr_reader :store
  def initialize
    @store = Store.new
  end

  def run
    scraper = Scraper.new("Marrickville", "nsw")
    scraper.scrape_all_pages

    scraper.properties.each do |property|
      store.save_property_sale(property.sale_data)
    end
  end
end