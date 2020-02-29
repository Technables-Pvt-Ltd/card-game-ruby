class ChangePositionToBeIntegerGamePlayer < ActiveRecord::Migration[6.0]
  def change
    change_column :game_players, :position, :integer
  end
end
