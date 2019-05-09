require_relative '../config/environment'
require 'pry'

$current_user = nil

  def get_or_create_user
    prompt = TTY::Prompt.new
    input = prompt.yes?("Hello Pokéologist! Welcome to Aaron & Andrew's Pokémon Research Center. Are you new here?")
    if input == true
      $current_user = current
    else input == false
      $current_user = get_user
    end
  end


  def get_user
    prompt = TTY::Prompt.new
    existing_name = prompt.ask("Oh of course, I'm sorry I didn't recognize you! Remind me what your name is?")
    if User.all.find_by(name: existing_name)
      puts "Welcome back, #{existing_name}!"
      $current_user = User.find_by(name: existing_name)
      pokemon_to_research
    else User.find_by(name: existing_name) == nil
      puts "Sorry, that name is not in our records. Please try again."
    end
  end


  def create_user
    prompt = TTY::Prompt.new
    username = prompt.ask("Great! What is your name?")
    user_catchphrase = prompt.ask("What is your catchphrase?")
    current = User.create(name: username, catchphrase: user_catchphrase)
    puts "Nice to meet you #{username}! #{user_catchphrase}!"
    pokemon_to_research
  end


  def pokemon_to_research
    prompt = TTY::Prompt.new
    if $current_user.teams.empty?
      puts "You're currently not researching any pokemon. Let's make you a team! Time to choose some Pokémon."
      search_option = prompt.select("How would you like to search?", %w(Name Type Pokedex Stats))
      if search_option == "Name"
        name = prompt.ask("Please enter the name of the Pokêmon you would like to research:")
        found_pokemon = Pokemon.find_by(name: name)
        input = prompt.yes?("Add #{name} to your team?")
        if input == true
          binding.pry
          $current_user.id.teams << found_pokemon
        end
      end
    end
  end





get_or_create_user
# pokemon_to_research
# Fake script:
# user = create_user
# someotherusermethod(user)
