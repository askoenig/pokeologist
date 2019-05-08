# require 'net/http'
# require 'open-uri'
require 'json'
require 'rest-client'
require 'pry'

class GetPokemon

  def get_api()
    # url = "https://pokeapi.co/api/v2/pokemon?limit=151"
    response_string = RestClient.get("https://pokeapi.co/api/v2/pokemon?limit=151")
    response_hash = JSON.parse(response_string)
  end

  def get_151_pokemon()
    pokemon_info = {}
    for id_or_name in (1..151)
      response_string = RestClient.get("https://pokeapi.co/api/v2/pokemon/#{id_or_name}")
      response_hash = JSON.parse(response_string)
      stats = {}
      types = {}
      if response_hash["types"].length < 2
        types[:type_1] = "#{response_hash["types"][0]["type"]["name"]}"
      else
        types[:type_1] = "#{response_hash["types"][0]["type"]["name"]}"
        types[:type_2] = "#{response_hash["types"][1]["type"]["name"]}"
      end

      stats[:name] = "#{response_hash["name"]}"
      stats[:hp] = "#{response_hash["stats"][5]["base_stat"]}"
      stats[:attack]= "#{response_hash["stats"][4]["base_stat"]}"
      stats[:defense] = "#{response_hash["stats"][3]["base_stat"]}"
      stats[:special_att] = "#{response_hash["stats"][2]["base_stat"]}"
      stats[:special_def] = "#{response_hash["stats"][1]["base_stat"]}"
      stats[:speed] = "#{response_hash["stats"][0]["base_stat"]}"
      # response_hash.pokemon_types
      merged = stats.merge(types)
      # pokemon_info["#{id_or_name}"] = stats
      pokemon_info["#{id_or_name}"] = merged
    end
  end

  def pokemon_types(id_or_name)
    response_string = RestClient.get("https://pokeapi.co/api/v2/pokemon/#{id_or_name}")
    response_hash = JSON.parse(response_string)
    types = {}
    if response_hash["types"].length < 2
      types[:type_1] = "#{response_hash["types"][0]["type"]["name"]}"
      types
    else
      types[:type_1] = "#{response_hash["types"][0]["type"]["name"]}"
      types[:type_2] = "#{response_hash["types"][1]["type"]["name"]}"
      types
    end
  end

end
