require "rspec"
require "fakeweb"
require "ostruct"
require Dir.pwd + "/scraper"

describe "Property Scraper" do
  let(:uri)      { "http://house.ksou.cn/p.php?q=Marrickville&region=Marrickville&sta=nsw" }
  let(:next_uri) { uri + "&p=1" }
  let(:iterator) { Iterator.new("Marrickville", "nsw") }

  before do
    @stream = File.open 'fixture.html', 'r'
    FakeWeb.register_uri(:get, uri, body: @stream, content_type: 'text/html')
    FakeWeb.register_uri(:get, next_uri, body: "Unhandled response", status: ["503", "unhandled response"])
  end

  after { @stream.close }

  describe "integration test" do
    it "saves the properties of the first page" do
      iterator.scrape_all_pages
      expect(iterator.properties[0].address).to   eq first_result[:address]
      expect(iterator.properties[0].price).to     eq first_result[:price]
      expect(iterator.properties[0].date_sold).to eq first_result[:date_sold]
      expect(iterator.properties[0].type).to      eq first_result[:type]
      expect(iterator.properties[0].bedrooms).to  eq first_result[:bedrooms]
      expect(iterator.properties[0].bathrooms).to eq first_result[:bathrooms]
      expect(iterator.properties[0].carspace).to  eq first_result[:carspace]
    end
  end
end

def first_result
  { address: "52 Ruby Street",
    price: 900000, 
    date_sold: Date.strptime("2014-08-01", "%Y-%m-%d"),
    type: "House", 
    bedrooms: 2, 
    bathrooms: 1, 
    carspace: 1
  }
end