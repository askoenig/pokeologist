# require 'pry'
# require_relative '../config/environment.rb'
Pokemon.delete_all
User.delete_all
Team.delete_all

def update_pokemons

  pokemon_hash = get_151_pokemon()
  for id in (1..151)
    Pokemon.create(

      name: pokemon_hash[id.to_s][:name],
      hp: pokemon_hash[id.to_s][:hp],
      attack: pokemon_hash[id.to_s][:attack],
      defense: pokemon_hash[id.to_s][:defense],
      special_att: pokemon_hash[id.to_s][:special_att],
      special_def: pokemon_hash[id.to_s][:special_def],
      speed: pokemon_hash[id.to_s][:speed],
      type_1: pokemon_hash[id.to_s][:type_1],
      type_2: pokemon_hash[id.to_s][:type_2],
      pokedex_number: id
    )
  end
end

update_pokemons
Team.create(user_id: 1, pokemon_id: 1, team_name: "dope")
Team.create(user_id: 1, pokemon_id: 4, team_name: "dope2")
Team.create(user_id: 1, pokemon_id: 7, team_name: "dope3")

User.create(name: "Aaron", catchphrase: "Ay Ay Ron!")
