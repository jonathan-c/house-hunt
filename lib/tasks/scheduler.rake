
require 'open-uri'


desc "This task is called by the Heroku scheduler add-on"

task :update => :environment do
	nassau = "http://www.realtor.com/realestateandhomes-search/Nassau-County_NY/beds-4/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"
	suffolk = "http://www.realtor.com/realestateandhomes-search/Suffolk-County_NY/beds-4/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"
	
	@list = List.create

	def save_page(url)
		agent = Mechanize.new
		houses = []
		page = agent.get(url)
		props = page.search(".srp-item-address")

		props.each do |i|
			street_address = i.search(".listing-street-address").children.to_html
			number = street_address.split(" ", 2)[0]
			street = street_address.split(" ", 2)[1]
			houses<<{number: number,
					street: street,
					city: i.search(".listing-city").children.to_html,
					state: i.search(".listing-region").children.to_html,
					zip: i.search(".listing-postal").children.to_html,
					url: "http://www.realtor.com"+i.search("a").attr("href").value
					}
		end

		houses.each do |i|
			house = House.find_by_url(i[:url])
			if !house 
				house = House.create(
		  				number: i[:number].to_i,
		  				street: i[:street],
		  				city: i[:city],
		  				state: i[:state],
		  				zip: i[:zip].to_i,
		  				url: i[:url]
		  				)
				HouseList.create(list_id: @list.id, house_id: house.id)
				send_text("+15166582879", "New House Listed! #{house.url}") 
			end
		end
	end

	
	save_page(suffolk) 
	save_page(nassau)

	if List.last.houses == []
		List.last.destroy 
	else
		List.notify_houses_added
	end
end