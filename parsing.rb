def your_property_investment_magazine_parsed_data
  require "nokogiri"
  require "open-uri"
  url = "https://www.yourinvestmentpropertymag.com.au/top-suburbs/vic-3144-malvern.aspx"
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)

  yipm_median_house_price = html_doc.search(".grayborder_roundbottombox > table > tbody > tr:nth-child(2) > td.align_r.House.Median")
  yipm_median_unit_price = html_doc.search(".grayborder_roundbottombox table tbody tr:nth-child(2) td.align_r.Unit.Median")
  yipm_capital_growth_house = html_doc.search(".grayborder_roundbottombox table tbody tr:nth-child(5) td.align_r.House.MedianGrowthThisYr")
  yipm_capital_growth_unit = html_doc.search(".grayborder_roundbottombox table tbody tr:nth-child(5) td.align_r.Unit.MedianGrowthThisYr")
  yipm_rental_yield_house = html_doc.search(".grayborder_roundbottombox table tbody tr:nth-child(8) td.align_r.House.GrossRentalYield")
  yipm_rental_yield_unit = html_doc.search(".grayborder_roundbottombox table tbody tr:nth-child(8) td.align_r.Unit.GrossRentalYield")

  puts ""
  puts "Data From 'Your Investment Property Magazine'"
  puts "------------------------------------------------------"
  puts "Median House Price = #{yipm_median_house_price}"
  puts "Median Unit Price = #{yipm_median_unit_price.text.strip}"
  puts "Capital Growth Houses = #{yipm_capital_growth_house.text.strip}"
  puts "Capital Growth Units = #{yipm_capital_growth_unit.text.strip}"
  puts "Rental Yield Houses = #{yipm_rental_yield_house.text.strip}"
  puts "Rental Yield Units = #{yipm_rental_yield_unit.text.strip}"
  puts "------------------------------------------------------"
end


def smart_property_investment_parsed_data
  require "nokogiri"
  require "open-uri"
  url = "https://www.smartpropertyinvestment.com.au/data/vic/3066/collingwood"
  html_file = URI.open(url).read
  doc = Nokogiri::HTML(html_file)
  # file = "smart_property_investment_richmond.html"
  # doc = Nokogiri::HTML(File.open(file), nil, "utf-8")

  ypim_rental_yield_house = doc.search(".b-suburbprofilepage__stat div table tfoot tr:nth-child(3) td:nth-child(2)")
  ypim_rental_yield_unit = doc.search(".b-suburbprofilepage__stat div table tfoot tr:nth-child(3) td:nth-child(3)")
  ypim_house_price = doc.search(".b-suburbprofilepage__stat div table tbody tr:nth-child(1) td:nth-child(2)")
  ypim_unit_price = doc.search(".b-suburbprofilepage__stat div table tbody tr:nth-child(1) td:nth-child(3)")
  ypim_capital_growth_house = doc.search(".b-suburbprofilepage__stat div table tbody tr:nth-child(7) td:nth-child(2)")
  ypim_capital_growth_unit = doc.search(".b-suburbprofilepage__stat div table tbody tr:nth-child(7) td:nth-child(3)")

  puts ""
  puts "Data From 'Smart Property Investment'"
  puts "------------------------------------------------------"
  puts "Rental Yield Houses = #{ypim_rental_yield_house.text.strip}"
  puts "Rental Yield Units = #{ypim_rental_yield_unit.text.strip}"
  puts "Median House Price = #{ypim_house_price.text.strip}"
  puts "Median Unit Price = #{ypim_unit_price.text.strip}"
  puts "10 yr Capital Growth Rate Houses = #{ypim_capital_growth_house.text.strip}"
  puts "10 yr Capital Growth Rate Units = #{ypim_capital_growth_unit.text.strip}"
  puts "------------------------------------------------------"
end

# run this method to update NSW suburb data
def nsw_suburbs_all
  require 'nokogiri'
  require "open-uri"
  count = 2136
  state_file = 'nsw_suburbs.html'
  state_doc = Nokogiri::HTML(File.open(state_file), nil, 'utf-8')
  number_of_suburbs = state_doc.search('.suburbs li').length
  href = state_doc.search("#container > ul > li:nth-child(#{count}) > a")[0].to_s.gsub(' ', '-')
  suburb = state_doc.search("#container > ul > li:nth-child(#{count}) > a").text.downcase
  state = href[66..68] #need to correct regex, not hardcode as some states have 2 characters
  # zip = href.gsub([\d]+)
  zip = href[70..73] #need to correct regex, not hardcode as some states have 2 characters

  multi_suburb_array = []
  # 2137 is the suburb number as March 20 2022
  until count > 2137
    url = "https://www.yourinvestmentpropertymag.com.au/top-suburbs/#{state}-#{zip}-#{suburb}.aspx".gsub(' ', '-')
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    suburb_data = []
    suburb = html_doc.search(".share ul li:nth-child(3)").text.split
    state = html_doc.search(".share > ul > li:nth-child(2) > a").text.split.first
    postcode = html_doc.search(".share ul li:nth-child(3)").text.split.last[1..-2]
    price = html_doc.search("div.grayborder_roundbottombox td.align_r.House.Median").text.strip[1..-1]#.tr(',', '').to_i
    # price = price.tap { |c| c.delete(',') }.to_i
    number_of_sales = html_doc.search("div.grayborder_roundbottombox td.align_r.House.NumberSold").text.to_i
    growth_rate = html_doc.search("div.grayborder_roundbottombox td.align_r.House.MedianGrowthThisYr").text.to_f
    rental_yield = html_doc.search("div.grayborder_roundbottombox td.align_r.House.GrossRentalYield").text.strip.chop.to_f
    # supply_and_demand_rating = html_doc.search(".grayborder_roundbottombox div:nth-child(7) span.avg a").text.first
    suburb_data.push(suburb.join(' ')[0..-7].chop, state, postcode, price, number_of_sales, growth_rate, rental_yield) #supply_and_demand_rating)
    multi_suburb_array << suburb_data
    href = state_doc.search("#container > ul > li:nth-child(#{count}) > a")[0].to_s
    suburb = state_doc.search("#container > ul > li:nth-child(#{count}) > a").text.downcase
    state = href[66..68]
    zip = href[70..73]
    count += 1
  end
  p multi_suburb_array
end

def scraped_suburb_data
  require 'nokogiri'
  require "open-uri"
  url = 'https://www.yourinvestmentpropertymag.com.au/top-suburbs/nsw-2041-balmain.aspx'
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  # number_of_suburbs = state_doc.search('.suburbs li').length
  # p number_of_suburbs
  suburb_data = []
  # suburb_file = 'richmond.html'
  # suburb_doc = Nokogiri::HTML(File.open(suburb_file), nil, 'utf-8')
  suburb = html_doc.search(".share ul li:nth-child(3)").text.split.first
  state = html_doc.search(".share > ul > li:nth-child(2) > a").text.split.first
  postcode = html_doc.search(".share ul li:nth-child(3)").text.split.last[1..-2]
  price = html_doc.search("div.grayborder_roundbottombox td.align_r.House.Median").text.strip[1..-1]
  price = price.tap { |c| c.delete!(',') }.to_i
  number_of_sales = html_doc.search("div.grayborder_roundbottombox td.align_r.House.NumberSold").text.to_i
  growth_rate = html_doc.search("div.grayborder_roundbottombox td.align_r.House.MedianGrowthThisYr").text.to_f
  rental_yield = html_doc.search("div.grayborder_roundbottombox td.align_r.House.GrossRentalYield").text.strip.chop.to_f
  supply_and_demand_rating = html_doc.search(".grayborder_roundbottombox div:nth-child(7) span.avg a").first.text
  suburb_data.push(suburb, state, postcode, price, number_of_sales, growth_rate, rental_yield, supply_and_demand_rating)
  # p suburb_data
end


# scraped_suburb_data
# nsw_suburbs_all
# smart_property_investment_parsed_data
# your_property_investment_magazine_parsed_data


# then get two more sources (Smart Property Investment & ABS (but compare with state and national averages not jus a contextless figure))


#listings-app-container > div.details > div.details__wrapper > div.details__hero > div > div > div.hero-poster__pip > div > div.property-info__header > div.property-info__address-actions > h1

#listings-app-container > footer > div.REASiteLinks__REASiteLinksContainer-sc-hxkfl9-8.cKuzRS > div > div.REASiteLinks__PersonalisedAdvertising-sc-hxkfl9-10.cdifKe > p


def average_room_price(suburb, postcode, state)
  require "open-uri"
  require "nokogiri"
  r_url = "https://www.realestate.com.au/neighbourhoods/#{suburb}-#{postcode}-#{state}"
  r_html_file = URI.open(r_url).read
  r_html_doc = Nokogiri::HTML(r_html_file)
  # f_url = "https://flatmates.com.au/value-my-room/#{suburb}-#{postcode}"
  # f_html_file = URI.open(f_url).read
  # f_html_doc = Nokogiri::HTML(f_html_file)
  room_price = f_html_doc.search(".content-wrapper > div:nth-child(2) > div > div.value-my-room-show > div.value-header > div.average-rent > div > p > span.average-rent-box > span.average-rent-number").text
  supply = f_html_doc.search(".content-wrapper > div:nth-child(2) > div > div.value-my-room-show > div.supply-and-demand > div.ratio > div > table > tbody > tr:nth-child(1) > td.people-looking-chart").text
  demand = f_html_doc.search(".content-wrapper > div:nth-child(2) > div > div.value-my-room-show > div.supply-and-demand > div.ratio > div > table > tbody > tr:nth-child(1) > td.rooms-offered-chart").text
  three_bedder = r_html_doc.search("slide-section.default-slide-section.median-price-subsections.houses > div.median-price-subsection.rent-subsection > div.subsection-breakdowns > a.breakdown-subsection.middle-subsection > div.price.strong").text
  four_bedder = r_html_doc.search(".slide-section.default-slide-section.median-price-subsections.houses > div.median-price-subsection.rent-subsection > div.subsection-breakdowns > a.breakdown-subsection.right-subsection > div.price.strong").text
  puts three_bedder
  puts four_bedder
  # puts "Average Room Price in #{suburb} is :#{room_price}. The potential returns if leasing rooms invidually in a 3 bedroom property are $100, while in a 4 bedroom property they are $100.

  # There are #{supply} people looking for every #{demand} room offered."
end

#container > div.content_bottom > div.content.float_l.marginright30.topsuburbsdetail > h1


def room_price(suburb, postcode, state)
  require "open-uri"
  require "nokogiri"
  f_url = "https://flatmates.com.au/value-my-room/#{suburb}-#{postcode}"
  f_html_file = URI.open(f_url).read
  f_html_doc = Nokogiri::HTML(f_html_file)
  room_price = f_html_doc.search(".content-wrapper > div:nth-child(2) > div > div.value-my-room-show > div.value-header > div.average-rent > div > p > span.average-rent-box > span.average-rent-number").text
  supply = f_html_doc.search(".content-wrapper > div:nth-child(2) > div > div.value-my-room-show > div.supply-and-demand > div.ratio > div > table > tbody > tr:nth-child(1) > td.people-looking-chart").text
  demand = f_html_doc.search(".content-wrapper > div:nth-child(2) > div > div.value-my-room-show > div.supply-and-demand > div.ratio > div > table > tbody > tr:nth-child(1) > td.rooms-offered-chart").text

  puts "Average Room Price is :#{room_price}.
  There are #{supply} people looking for every #{demand} room offered."
end

room_price("collingwood", "3066", "vic")
