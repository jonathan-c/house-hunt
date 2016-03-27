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
    if List.previous
      List.current.each do |house|
        if !List.previous.include?(house)
          #Notification.create(message: "#{house} has been added!", list_id: List.last.id)
          puts "#{house.comma_price} #{house.number} #{house.street} #{house.city}, #{house.state} #{house.state}"
        end
      end
    else
      List.current.each do |house|
        puts "#{house.comma_price} #{house.number} #{house.street} #{house.city}, #{house.state} #{house.state}"
      end
    end
  end
end
