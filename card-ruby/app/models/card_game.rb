class CardGame < ApplicationRecord
    self.locking_column = :lock_card_game
end
