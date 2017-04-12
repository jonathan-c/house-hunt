def url(city)
	"http://www.realtor.com/realestateandhomes-search/#{city}/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"
end
# nassau = "http://www.realtor.com/realestateandhomes-search/Nassau-County_NY/beds-4/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"
# suffolk = "http://www.realtor.com/realestateandhomes-search/Suffolk-County_NY/beds-4/type-multi-family-home/price-na-751000/shw-nl?pgsz=50"

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
			if (i[:number] != 48 && i[:street] != "Grace St") && !i[:url].include?("Brooklyn_NY_11234_M42259-00115") && !i[:url].include?("Brooklyn_NY_11208_M40395-78686")
				house = House.create(
		  				number: i[:number].to_i,
		  				street: i[:street],
		  				city: i[:city],
		  				state: i[:state],
		  				zip: i[:zip].to_i,
		  				url: i[:url]
		  				)
				HouseList.create(list_id: @list.id, house_id: house.id)
				#send_text("+1<area code><number>", "New House Listed! #{house.url}") 
			end
		end
	end
end

# save_page(url("Suffolk-County_NY")) 
save_page(url("Nassau-County_NY"))
# save_page(url("Montclair_NJ"))
# save_page(url("Caldwell_NJ"))
# save_page(url("Ridgewood_NJ"))
# save_page(url("Union-City_NJ"))
# save_page(url("Guttenberg_NJ"))
# save_page(url("Maplewood_NJ"))
# save_page(url("Westwood_NJ"))
# save_page(url("Weehawken_NJ"))
# save_page(url("Queens_NY"))
# save_page(url("Brooklyn_NY"))
# save_page(url("Manhattan_NY"))
if List.last.houses == []
	List.last.destroy 
else
	List.notify_houses_added
end

@houses = House.where("created_at >= ?", Time.zone.now.beginning_of_day)

List.last.houses.each do |house|
	puts house.print
	puts house.url
	puts "--------"
end