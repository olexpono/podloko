class RoomsController < ApplicationController
  ### ACCESSED VIA BROWSER (HTML) ###
  # index of the site / shows available rooms
  def index
    @rooms = Room.order("updated_at DESC").limit(10)
  end

  # shows the currently available songs from a given room's ipod
  def show
    @room = Room.find_by_name(params[:id])
    @room_tracks = ActiveSupport::JSON.decode(@room.tracks_json || "[]")
    respond_to do |wants|
      wants.html
      wants.json { render :text => @room.to_json }
    end
  end

  def request_library_update
    @room = Room.find_by_name(params[:id])
    if @room
      Pusher[@room.name].trigger('update_library', {:message => "nil"})
    end
    flash[:notice] = "Fetching Library from iPod, check back in 10 seconds!"
    redirect_to :action => :show
  end
  
  def stop
    @room = Room.find_by_name(params[:id])
    if @room
      Pusher[@room.name].trigger('stop', [])
    end
    flash[:notice] = "Stopping iPod."
    redirect_to :action => :show
  end

  def play
    @album = params[:album]
    @room = Room.find_by_name(params[:id])
    if @room
      Pusher[@room.name].trigger('play', {:album => @album})
    end
    flash[:notice] = "Playing #{@album} on iPod"
    redirect_to :action => :show
  end

  ### ACCESSED VIA PHONE (API) ###
  skip_before_filter :verify_authenticity_token, 
                :only => [:ping, :update_library]
  # occasionally pingback from phone, should update recently_active
  def ping
    render :text => {"success" => false}.to_json
  end
  
  def claim
    @room = Room.taken?(params[:id]) ? Room.find_by_name(params[:id]) : nil
    password_hash = nil
    message = ""
    if params.has_key?(:password)
      password_hash = Digest::SHA2.hexdigest(params[:password]) 
    end
    unless @room
      @room = Room.create(:name => params[:id], :password_hash => password_hash)
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
    @room = Room.find_by_name(params[:id])
    json = ActiveSupport::Base64.decode64 params[:library]
    library_list = ActiveSupport::JSON.decode json
    
    @room.update_attribute(:tracks_json, json)
    Rails.logger.info("Room #{@room.name} ---- JSON FROM PHONE ----\n\n#{json}\n\n")
    render :text => {"success" => true}.to_json
  end

end
