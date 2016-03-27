class List < ActiveRecord::Base
  has_many :house_lists
  has_many :houses, :through => :house_lists, :order => 'price DESC'

  def self.previous
    List.all[-2].try(:houses)
  end

  def self.current
    List.last.houses
  end

  def self.change?
    if List.previous == List.current
      false
    else
      true
    end
  end

  def self.notify_houses_added
    if List.last.created_at.to_date == Date.current
      NewListings.sample_email.deliver
    end
  end
end
