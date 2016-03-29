# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HouseHunt::Application.initialize!

def send_text(to, body)
	@client = Twilio::REST::Client.new
  	@client.account.messages.create(
		:from => "+16314985508",
	  	:to => to,
	  	:body => body
  	)
end
