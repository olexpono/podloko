class RoomsController < ApplicationController
  ### ACCESSED VIA BROWSER (HTML) ###
  # index of the site / shows available rooms
  def index
    @rooms = Room.order("updated_at DESC").limit(10)
  end

  # shows the currently available songs from a given room's ipod
  def show
    @room = Room.find(params[:id])
  end

  ### ACCESSED VIA PHONE (API) ###
  skip_before_filter :verify_authenticity_token, 
                :only => [:ping, :update_library]
  # occasionally pingback from phone, should update recently_active
  def ping
    render :text => {"success" => false}.to_json
  end
  
  def claim
    @room = Room.find(params[:id])
    password_hash = nil
    message = ""
    if params.has_key?(:password)
      password_hash = Digest::SHA2.hexdigest(params[:password]) 
    end
    unless @room 
      @room = Room.create(:id => params[:id], :password_hash => password_hash)
      message << "New Room Created. "
    end
    if @room.last_active < 3.hours.ago
      # stale room
      @room.update_attributes(:password_hash => password_hash)
      message << "You have reclaimed Room ##{params[:id]}. "
    end
    
    render :text => {"success" => true, "message" => message}.to_json
  end

  # POST from the phone with ipod library (query result)
  def update_library
    @room = Room.find(params[:id])
    json = ActiveSupport::Base64.decode64 params[:library]
    library_list = ActiveSupport::JSON.decode json
    
    @room.update_attribute(:tracks_json, json)
    # puts " ---- JSON FROM PHONE ----\n\n#{json}\n\n"
    render :text => {"success" => false}.to_json
  end

end
