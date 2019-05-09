class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :pokemon


  # validate :team_count, :on => :create
  #   def team_count
  #     if self.user.pokemons(:reload).count == 6
  #         errors.add(:base, "You already have 6 Pokémon!")
  #     end
  #   end

end
