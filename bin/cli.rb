require_relative '../config/environment'
require 'pry'

$current_user = nil
$team_name = nil
$existing_name = nil

  def get_or_create_user
    $current_user = nil

    prompt = TTY::Prompt.new
    input = prompt.yes?("Hello Pokéologist! Welcome to Aaron & Andrew's Pokémon Research Center. Are you new here?")
    if input == true
      $current_user = create_user
    else input == false
      $current_user = get_user
    end
  end


  def get_user

    prompt = TTY::Prompt.new
    $existing_name = prompt.ask("Oh of course, I'm sorry I didn't recognize you! Remind me what your name is?")
    if User.find_by(name: $existing_name)
      puts "Welcome back, #{$existing_name}!"
      $current_user = User.find_by(name: $existing_name.to_s)
      $team_name = Team.find_by(user_id: $current_user.id).team_name
    else User.find_by(name: $existing_name) == nil
      puts "Sorry, that name is not in our records. Please try again."
      get_or_create_user
    end
    pokemon_to_research
  end

  def create_user
    prompt = TTY::Prompt.new
    username = prompt.ask("Great! What is your name?")
    user_catchphrase = prompt.ask("What is your catchphrase?")
    $current_user = User.create(name: username, catchphrase: user_catchphrase)
    puts "Nice to meet you #{username}! #{user_catchphrase}!"
    pokemon_to_research
  end


  def pokemon_to_research
    $team_name = nil
    prompt = TTY::Prompt.new
    if $current_user.pokemons.empty? == true
      puts "You're currently not researching any pokemon."
      $team_name = prompt.ask("Let's make you a team! What would you like to name your team?")
      puts "Great. Now time to choose some Pokémon."
      search_option = prompt.select("How would you like to search?", %w(Name Type Pokédex))
      if search_option == "Name"
        find_pokemon_by_name
      elsif search_option == "Type"
        find_pokemon_by_type
      else search_option == "Pokédex"
        find_pokemon_by_pokedex
      end
    else
      input = prompt.select("What would you like to do?") do |menu|
        menu.choice 'View Team', 1
        menu.choice 'Add Pokemon',2
        menu.choice 'Remove Pokemon',3
        menu.choice 'Exít',4
      end
      if input == 1
        list_of_user_pokemon = $current_user.pokemons.map(&:name)
        choices = Hash.new
        list_of_user_pokemon.each.with_index(1) {|str, idx| choices[str.to_s] = idx}
        pokemon_chosen = prompt.select("Here's your team. Select one to research:", choices)
        name_of_pokemon = choices.key(pokemon_chosen)
        pokemon_details = Pokemon.find_by(name: name_of_pokemon)
        puts "hp: #{pokemon_details.hp}"
        puts "attack: #{pokemon_details.attack}"
        puts "defense: #{pokemon_details.defense}"
        puts "special attack: #{pokemon_details.special_att}"
        puts "special defense: #{pokemon_details.special_def}"
        puts "speed: #{pokemon_details.speed}"
        puts "type: #{pokemon_details.type_1} #{pokemon_details.type_2}"
        pokemon_to_research
      elsif input == 2
        search_option = prompt.select("How would you like to search?", %w(Name Type Pokédex))
        if search_option == "Name"
          find_pokemon_by_name
        elsif search_option == "Type"
          find_pokemon_by_type
        else search_option == "Pokédex"
          find_pokemon_by_pokedex
        end
      elsif input == 3
        list_of_user_pokemon_to_delete = $current_user.pokemons.map(&:name)
        choices_to_delete = Hash.new
        list_of_user_pokemon_to_delete.each.with_index(1) {|str, idx| choices_to_delete[str.to_s] = idx}
        pokemon_chosen_to_delete = prompt.select("Here's your team. Select one to remove:", choices_to_delete)
        name_of_pokemon_to_delete = choices_to_delete.key(pokemon_chosen_to_delete)
        binding.pry
        pokemon_for_deletetion = Team.find_by(pokemon_id: Pokemon.find_by(name:name_of_pokemon_to_delete).id)
        pokemon_for_deletetion.delete
        $current_user.reload
        pokemon_to_research
      else input == 4
        get_or_create_user
      end
    end

  end

  def find_pokemon_by_name

    prompt = TTY::Prompt.new
    name = prompt.ask("Please enter the name of the Pokémon you would like to research:")
    if Pokemon.exists?(name: name.downcase)
     found_pokemon = Pokemon.find_by(name: name.downcase)
    else
      puts "Sorry, that pokemon does not exist"
      find_pokemon_by_name
    end
    input = prompt.yes?("Add to your team?")
    if input == true
      Team.create(user_id: $current_user.id, pokemon_id: found_pokemon.id, team_name: $team_name)
      $current_user.reload
      # pokemon_to_research
    # elsif input == true
    #   puts "Sorry, your team is full. Make another team."
    else
      pokemon_to_research
    end
    pokemon_to_research
  end

  def find_pokemon_by_type

    prompt = TTY::Prompt.new
    user_type = prompt.select("How would you like to search?", %w(Bug Dragon Electric Fighting Fire Flying Ghost Grass Ground Ice Normal Poison Psychic Rock Water))
    list_of_pokemon_by_type = Pokemon.search_by_type(user_type.downcase.to_s).map(&:name)
    choices = Hash.new
    list_of_pokemon_by_type.each.with_index(1) {|str, idx| choices[str.to_s] = idx}
    selected_pokemon = prompt.select("Select the pokémon you would like to add to your team:", choices)
    name_of_pokemon = choices.key(selected_pokemon)
    found_pokemon = Pokemon.find_by(name: name_of_pokemon)
    input = prompt.yes?("Add to your team?")
    if input == true && $current_user.teams.size <= 6
      Team.create(user_id: $current_user.id, pokemon_id: found_pokemon.id, team_name: $team_name)
      $current_user.reload
      pokemon_to_research
    elsif input == true && $current_user.teams.size == 6
      puts "Sorry, your team is full. Make another team."
    else
      pokemon_to_research
    end
  end


  def find_pokemon_by_pokedex

    prompt = TTY::Prompt.new
    user_pokedex = prompt.ask("Please enter the Pokédex number of the Pokémon you would like to research:")

    if Pokemon.exists?(pokedex_number: user_pokedex)
     found_pokemon = Pokemon.find_by(pokedex_number: user_pokedex)
    else
      puts "Sorry, that pokemon does not exist"
      find_pokemon_by_pokedex
    end

    input = prompt.yes?("Add to your team?")
    if input == true && $current_user.teams.size <= 6
      Team.create(user_id: $current_user.id, pokemon_id: found_pokemon.id, team_name: $team_name)
      $current_user.reload
      pokemon_to_research
    elsif input == true && $current_user.teams.size == 6
      puts "Sorry, your team is full. Make another team."
    else
      pokemon_to_research
    end
  end


  # def confirm_pokemon_addition
  #   prompt = TTY::Prompt.new
  #   input = prompt.yes?("Add to your team?")
  #   if input == true && $current_user.teams.size <= 6
  #     Team.create(user_id: $current_user.id, pokemon_id: found_pokemon, team_name: $team_name)
  #   else
  #     puts "Sorry, your team is full."
  #   end
  #   pokemon_to_research
  # end





get_or_create_user
# pokemon_to_research
# Fake script:
# user = create_user
# someotherusermethod(user)
