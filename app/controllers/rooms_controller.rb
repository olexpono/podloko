class RoomsController < ApplicationController
  ### ACCESSED VIA BROWSER (HTML) ###
  # index of the site / shows available rooms
  def index
  end

  # shows the currently available songs from a given room's ipod
  def show
  end

  ### ACCESSED VIA PHONE (API) ###
  skip_before_filter :verify_authenticity_token, 
                :only => [:ping, :update_library]
  # occasionally pingback from phone, should update recently_active
  def ping
    render :text => {"success" => false}.to_json
  end

  # POST from the phone with ipod library (query result)
  def update_library
    json = ActiveSupport::Base64.decode64 params[:library]
    puts " ---- JSON FROM PHONE ----\n\n#{json}\n\n"
    render :text => {"success" => false}.to_json
  end

end
