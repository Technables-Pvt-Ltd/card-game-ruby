class AddPlaycountToGameplayer < ActiveRecord::Migration[6.0]
  def change
    add_column :game_players, :playcount, :integer
  end
end
