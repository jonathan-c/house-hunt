class NewListings < ActionMailer::Base
  default from: "joncastillo123@gmail.com"

  def sample_email
    mail(to: "askcastillo@gmail.com", subject: 'New Listings!')
  end
end
