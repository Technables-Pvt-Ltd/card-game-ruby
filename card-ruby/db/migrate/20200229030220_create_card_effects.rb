class CreateCardEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :card_effects do |t|
      t.string :name
      t.string :effectclass

      t.timestamps
    end
  end
end
