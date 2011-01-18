class RoomsController < ApplicationController
  ### ACCESSED VIA BROWSER (HTML) ###
  # index of the site / shows available rooms
  def index
  end

  # shows the currently available songs from a given room's ipod
  def show
  end

  ### ACCESSED VIA PHONE (API) ###

  # occasionally pingback from phone, should update recently_active
  def ping
  end

  # POST from the phone with ipod library (query result)
  def update_library
  end

end
