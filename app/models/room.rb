class Room < ActiveRecord::Base
  before_save :update_last_active

  def update_last_active
    self.last_active = Time.now
  end
end
