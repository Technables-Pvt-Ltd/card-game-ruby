class CreateDeckCards < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_cards do |t|
      t.integer :deckid
      t.string :name
      t.string :cardclass

      t.timestamps
    end
  end
end
