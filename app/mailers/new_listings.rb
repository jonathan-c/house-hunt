class NewListings < ActionMailer::Base
  default from: ""

  def sample_email
    mail(to: "", subject: 'New Listings!')
  end
end
