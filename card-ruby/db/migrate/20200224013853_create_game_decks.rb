class CreateGameDecks < ActiveRecord::Migration[6.0]
  def change
    create_table :game_decks do |t|
      t.integer :gameid
      t.integer :deckid
      t.string :userid
      t.boolean :isselected

      t.timestamps
    end
  end
end
