class Scraper
  require "mechanize"
  URL = "http://house.ksou.cn/p.php?"

  attr_reader :agent, :suburb, :state, :uri, :page,
              :scraper, :properties

  def initialize(suburb, state)
    @agent      = Mechanize.new
    @suburb     = suburb
    @state      = state
    @page       = -1
    @properties = []
    @uri        = gen_next_page_uri
  end

  def scrape_all_pages
    scrape_current_page if page == 0
    catch :no_more_pages_to_scrape do
      loop { scrape_next_page }
    end
  end

  private
  def gen_next_page_uri
    @page = page + 1
    URL + "q=#{ suburb }&region=#{ suburb }&sta=#{ state }&p=#{ page }"
  end

  def scrape_next_page
    @uri = gen_next_page_uri
    scrape_current_page
  end

  def scrape_current_page
    begin; agent.get(uri)
    rescue response_error; throw :no_more_pages_to_scrape
    end
    extract_pages_data
  end

  def response_error
    Mechanize::ResponseCodeError
  end

  def extract_pages_data
    raw_contents = agent.page.search("table#mainT table tr td[2] table")

    raw_contents.each do |raw_content|
      property = Property.new(raw_content, suburb, state)
      @properties << property if property.valid?(properties)
    end
  end
end