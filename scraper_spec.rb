require "rspec"
require "fakeweb"
require "ostruct"
require Dir.pwd + "/scraper"

class PropertyMock < OpenStruct
  def initialize(blah); end
end

describe "Property Scraper" do
  let(:uri)     { "http://house.ksou.cn/p.php?q=Marrickville&s=1&region=Marrickville&sta=nsw" }
  let(:scraper) { Scraper.new(uri) }

  before do
    @stream = File.open("#{ Dir.pwd }/fixtures/fixture.html", 'r')
    FakeWeb.register_uri(:get, uri, body: @stream, content_type: "text/html")
  end

  after { @stream.close }

  describe Scraper do
    describe "#extract_data" do
      before { expect(scraper.properties.length).to eq 0 }

      context "correct raw contents" do
        it "saves the property" do
          class PropertyMock < OpenStruct
            def valid?; true; end
          end
          scraper.extract_data(PropertyMock)
          expect(scraper.properties.length).to be > 1
        end
      end

      context "incorrect raw contents" do
        it "discards the property" do
          class PropertyMock < OpenStruct
            def valid?; false; end
          end
          scraper.extract_data(PropertyMock)
          expect(scraper.properties.length).to eq 0
        end
      end
    end
  end

  describe Property do
    let(:raw_contents) { scraper.agent.page.search("table#mainT table tr td[2] table") }
    let(:raw_content)  { raw_contents[0] }
    let(:property)     { Property.new(raw_content) }

    describe "#initialize" do
      context "correct raw content" do
        it "sets the Property's data" do
          expect(property.address).to   eq first_result[:address]
          expect(property.price).to     eq first_result[:price]
          expect(property.date_sold).to eq first_result[:date_sold]
          expect(property.type).to      eq first_result[:type]
          expect(property.bedrooms).to  eq first_result[:bedrooms]
          expect(property.bathrooms).to eq first_result[:bathrooms]
          expect(property.carspace).to  eq first_result[:carspace]
        end
      end
    end

    describe "#valid?" do
      context "correct raw content" do
        it "is valid" do
          expect(property.valid?).to eq true
        end
      end

      # context "incorrect raw content" do
      #   it "isn't valid" do
      #     uri     = "http://house.ksou.cn/p.php"
      #     scraper = Scraper.new(uri)
      #     stream  = File.open("#{ Dir.pwd }/fixtures/random_fixture.html", 'r')
      #     FakeWeb.register_uri(:get, uri, body: stream, content_type: "text/html")
      #     property = Property.new(scraper.agent.page)

      #     expect(property.valid?).to eq false
      #     stream.close
      #   end
      # end
    end
  end
end

def first_result
  { address: "14/345 Illawarra Road", 
    price: 650000, 
    date_sold: Date.strptime("2014-07-01", "%Y-%m-%d"),
    type: "Unit", 
    bedrooms: 2, 
    bathrooms: 1, 
    carspace: 1
  }
end