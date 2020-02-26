class CreateGamePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :game_players do |t|
      t.integer :gameid
      t.string :userid
      t.integer :deckid
      t.string :position
      t.integer :health
      t.integer :status
      t.boolean :hasturn

      t.timestamps
    end
  end
end
