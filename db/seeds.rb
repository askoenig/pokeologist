def update_pokemons

  for id in (1..151)
    Pokemon.create (
      name: get_151_pokemon[id.to_s][:name]
      hp: get_151_pokemon[id.to_s][:hp]
      attack: get_151_pokemon[id.to_s][:attack]
      defense: get_151_pokemon[id.to_s][:defense]
      special_att: get_151_pokemon[id.to_s][:special_att]
      special_def: get_151_pokemon[id.to_s][:special_def]
      speed: get_151_pokemon[id.to_s][:speed]
      type_1: get_151_pokemon[id.to_s][:type_1]
      type_2: get_151_pokemon[id.to_s][:type_2]
      pokedex_number: get_151_pokemon[id.to_s]
    )
  end
end
