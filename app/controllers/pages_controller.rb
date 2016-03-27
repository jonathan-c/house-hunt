class PagesController < ApplicationController
	def index
		NewListings.sample_email.deliver
	end

	def preview_email
		puts "preview"
	end
end
