class Team < ActiveRecord::Base
  belongs_to :users
  belongs_to :pokemons
  
end
