module RoomsHelper
  def room_list_item(room)
    content_tag "li" do
      "<span class='room_id'>#{room.id}</span><span class='room_name'>#{room.name || "Unnamed" }</span><em> - last active: #{room.last_active.strftime '%H:%M %p on %A'}</em>"
    end
  end

  def playable_album_name(room, album)
    link_to "#{album["album_artist"]} - #{album["album_name"]}",
            "#{room.to_param}/play_on_ipod?#{album["album_name"].to_query "album"}"
  end
end
