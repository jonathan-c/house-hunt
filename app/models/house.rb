class House < ActiveRecord::Base
  attr_accessible :city, :number, :price, :state, :street, :zip, :url
  has_many :house_lists
  has_many :lists, :through => :house_lists
  validates :number, uniqueness: { scope: [:street, :city] }

  def comma_price
  	self.price.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{','}").reverse
  end

  def print
  	"#{self.comma_price} - #{self.number} #{self.street} #{self.city}, #{self.state} #{self.zip}"
  end

end
