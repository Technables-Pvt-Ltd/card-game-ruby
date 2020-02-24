class CreateCardGames < ActiveRecord::Migration[6.0]
  def change
    create_table :card_games do |t|
      t.string :code
      t.string :userid
      t.integer :status

      t.timestamps
    end
  end
end
