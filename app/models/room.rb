class Room < ActiveRecord::Base
  before_save :update_last_active
  validates_uniqueness_of :name
  
  def self.taken?(room_name)
    where(:name => room_name).count >= 1 
  end 

  def to_param
    name
  end

  def update_last_active
    self.last_active = Time.now
  end
end
