require 'open-uri'
require 'nokogiri'

desc "This task is called by the Heroku scheduler add-on"

task :update => :environment do

	nassau = "http://www.realtor.com/realestateandhomes-search/Nassau-County_NY/beds-4/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"
	suffolk = "http://www.realtor.com/realestateandhomes-search/Suffolk-County_NY/beds-4/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"
	
	@list = List.create

	def save_page(url)
		houses = []
		page = Nokogiri::HTML(open(url))
		props = page.css('.js-record-user-activity').css('.srp-item')
		props.each do |i|
		  address = i.css('.srp-item-address')
		  price = i.css('.srp-item-price')
		  meta = i.css('.property-meta')
		  houses<<{"address" => address, "price" => price, "meta" => meta}
		end


		addresses = houses[0]["address"].css('.listing-street-address').children.to_a
		cities = houses[0]["address"].css('.listing-city').children.to_a
		states = houses[0]["address"].css('.listing-region').children.to_a
		zips = houses[0]["address"].css('.listing-postal').children.to_a
		prices = houses[0]["price"].css('.srp-item-price').children.to_a

		addresses.zip(cities, states, zips, prices).each do |address, city, state, zip, price|
			house = House.find_by_number_and_street(address.text.split(" ", 2)[0], address.text.split(" ", 2)[1])
			if !house 
				house = House.create(
		  				price: price.text.lstrip.rstrip.sub("$","").sub(",",""),
		  				number: address.text.split(" ", 2)[0],
		  				street: address.text.split(" ", 2)[1],
		  				city: city.text,
		  				state: state.text,
		  				zip: zip.text.to_i
		  				)
				HouseList.create(list_id: @list.id, house_id: house.id)
			end
		end
	end

	
	save_page(suffolk) 
	save_page(nassau)

	List.last.destroy if List.last.houses == []
	List.notify_houses_added
end