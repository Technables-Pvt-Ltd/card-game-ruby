class CreatePlayerCards < ActiveRecord::Migration[6.0]
  def change
    create_table :player_cards do |t|
      t.integer :playerid
      t.integer :cardid
      t.integer :o_deckid
      t.integer :cur_deckid
      t.integer :pile_type
      t.integer :card_health

      t.timestamps
    end
  end
end
