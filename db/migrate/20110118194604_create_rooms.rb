class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :name
      t.string :password_hash
      t.boolean :private
      t.timestamp :last_active
      t.text :tracks_json

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
