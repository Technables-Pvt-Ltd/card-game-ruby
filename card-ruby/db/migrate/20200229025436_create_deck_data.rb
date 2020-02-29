class CreateDeckData < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_data do |t|
      t.string :name
      t.string :deckclass

      t.timestamps
    end
  end
end
