class CreateCardEffectsMaps < ActiveRecord::Migration[6.0]
  def change
    create_table :card_effects_maps do |t|
      t.integer :cardid
      t.integer :effectid
      t.integer :count

      t.timestamps
    end
  end
end
