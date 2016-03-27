class HouseList < ActiveRecord::Base
  attr_accessible :house_id, :list_id
  belongs_to :list
  belongs_to :house
end
