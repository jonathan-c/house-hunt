class House < ActiveRecord::Base
  attr_accessible :city, :number, :price, :state, :street, :zip
  has_many :house_lists
  has_many :lists, :through => :house_lists
  validates :number, uniqueness: { scope: [:street, :city] }

  def comma_price
  	self.price.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{','}").reverse
  end
end
