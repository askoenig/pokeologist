require_relative '../config/environment'
require 'pry'

$current_user = nil
$team_name = nil
$existing_name = nil

  def get_or_create_user

    def sound
      system("open music/pokemon_theme_song_1.mp3")
    end
    sound

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
      empty_team
    else
      input = prompt.select("What would you like to do?") do |menu|
        menu.choice 'View Team', 1
        menu.choice 'Add Pokémon',2
        menu.choice 'Remove Pokémon',3
        menu.choice 'Fun Facts', 4
        menu.choice 'Exít',5
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
        sleep 0.5
        pokemon_to_research
      elsif input == 2
        search_option = prompt.select("How would you like to search?", %w(Name Type Pokédex Back))
        if search_option == "Name"
          find_pokemon_by_name
        elsif search_option == "Type"
          find_pokemon_by_type
        elsif search_option == "Pokédex"
          find_pokemon_by_pokedex
        else search_option == "Back"
          pokemon_to_research
        end
      elsif input == 3
        list_of_user_pokemon_to_delete = $current_user.pokemons.map(&:name)
        choices_to_delete = Hash.new
        list_of_user_pokemon_to_delete.each.with_index(1) {|str, idx| choices_to_delete[str.to_s] = idx}
        pokemon_chosen_to_delete = prompt.select("Here's your team. Select one to remove:", choices_to_delete)
        name_of_pokemon_to_delete = choices_to_delete.key(pokemon_chosen_to_delete)
        pokemon_for_deletetion = Team.find_by(pokemon_id: Pokemon.find_by(name:name_of_pokemon_to_delete).id)
        pokemon_for_deletetion.delete
        $current_user.reload
        pokemon_to_research
      elsif input == 4
        fun_facts
      else input == 5
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
    if input == true && $current_user.teams.size <= 6
      Team.create(user_id: $current_user.id, pokemon_id: found_pokemon.id, team_name: $team_name)
      $current_user.reload
    elsif input == true
      puts "Sorry, your team is full. Edit your team."
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
      puts "Sorry, your team is full. Edit your team."
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
      puts "Sorry, your team is full. Edit your team."
    else
      pokemon_to_research
    end
  end

  def empty_team
    prompt = TTY::Prompt.new
    puts "You're currently not researching any pokémon."
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
  end

  def fun_facts
    prompt = TTY::Prompt.new
    fun_fact_prompt = prompt.select('Choose a Fun Fact!') do |menu|
      menu.choice 'Weakest Overall Pokemon(ordered by attack)', 1
      menu.choice 'Strongest Overall Pokemon(ordered by attack)', 2
      menu.choice 'Highest Attack', 3
      menu.choice 'Lowest Attack', 4
      menu.choice 'Highest Defense', 5
      menu.choice 'Lowest Defense', 6
      menu.choice 'Highest HP', 7
      menu.choice 'Lowest HP', 8
      menu.choice 'Highest Speed', 9
      menu.choice 'Lowest Speed', 10
      menu.choice 'Highest Special Attack', 11
      menu.choice 'Lowest Special Attack', 12
      menu.choice 'Highest Special Defense', 13
      menu.choice 'Lowest Special Defense', 14
      menu.choice 'Back', 15
    end
    if fun_fact_prompt == 1
      weakest_overall_pokemon_names = Pokemon.weakest_overall_pokemon.sort_by(&:name).reverse.map(&:name)
      weakest_overall_pokemon_names.each_with_index {|name, i| puts "#{i+1}: #{name}"}
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 2
      strongest_overall_pokemon_names = Pokemon.strongest_overall_pokemon.sort_by(&:name).map(&:name)
      strongest_overall_pokemon_names.each_with_index {|name, i| puts "#{i+1}: #{name}"}
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 3
      puts "#{Pokemon.highest_attack.name}"
      puts "Attack:#{Pokemon.highest_attack.attack}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 4
      puts "#{Pokemon.lowest_attack.name}"
      puts "Attack:#{Pokemon.lowest_attack.attack}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 5
      puts "#{Pokemon.highest_defense.name}"
      puts "Defense:#{Pokemon.highest_defense.defense}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 6
      puts "#{Pokemon.lowest_defense.name}"
      puts "Defense:#{Pokemon.lowest_defense.defense}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 7
      puts "#{Pokemon.highest_hp.name}"
      puts "HP:#{Pokemon.highest_hp.hp}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 8
      puts "#{Pokemon.lowest_hp.name}"
      puts "HP:#{Pokemon.lowest_hp.hp}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 9
      puts "#{Pokemon.highest_speed.name}"
      puts "Speed:#{Pokemon.highest_speed.speed}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 10
      puts "#{Pokemon.lowest_speed.name}"
      puts "Speed:#{Pokemon.lowest_speed.speed}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 11
      puts "#{Pokemon.highest_special_attack.name}"
      puts "Special Attack:#{Pokemon.highest_special_attack.special_att}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 12
      puts "#{Pokemon.lowest_special_attack.name}"
      puts "Special Attack:#{Pokemon.lowest_special_attack.special_att}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 13
      puts "#{Pokemon.lowest_special_defense.name}"
      puts "Special Defense:#{Pokemon.lowest_special_defense.special_def}"
      sleep 0.5
      fun_facts
    elsif fun_fact_prompt == 14
      puts "#{Pokemon.lowest_special_defense.name}"
      puts "Special Defense:#{Pokemon.lowest_special_defense.special_def}"
      sleep 0.5
      fun_facts
    else fun_fact_prompt == 15
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

def snorlax
  puts"
..........................................................................
..........................................................................
.......................######...............######........................
.......................###########################........................
.......................###################O#######........................
.......................####.^^^^^^^^#^^^^^^^^^####........................
........#.##.#.#.......###^^------^^^^------^^^###........................
.........#######.......##^^^^^^^^^^^^^^^^^^^^^^/##........................
........##########.....#^^^^^^^^^^^^^^^^^^^^^^^^^##.......................
........############..##^^^^^^^^'------'^^^^^^^^^##.......................
........#############.#############################.......................
........###########@@#^^^^^^^^^^^^^^^^^^^^^^^^^^^^###.....................
........#########@@#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^##...................
........########@#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#@#.................
........#######@#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#@###..............
.........#####@#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#@#####............
.........####@#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^##@#####...........
..........##@##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^###@######.........
..........#@####^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^####@#######........
..........@######^^^^^^^^^^#################^^^^^^^^#######@#######.......
..........#################################################@#######.......
.........###############################################/|#@########......
.........####|\#######################################^/.|#@#########.....
.........####|.\^^^^^##############################^^^^~~^^@#/|######.....
.....----##^^^^^^^^^^^^###########################^^^^^^^^^^^~/#######....
......\..#^^^^^^^^^^^^^^########################^^^^^^^^^^^^^^^#..#.#.....
.......'#^^^^^^^^^^^^^^^#######################^^^^^^^^^^^^^^^^^#\........
........#^^^^^^^#####^^^#######################^^^#######^^^^^^^#/........
.....---#^^^^^#OOOOO#^^^#######################^^#OOOOOOO#^^^^^^#.........
......\.#^^^^#OOOOOO#^^^#######################^^#OOOOOOOO#^^^^^#.........
.......'#^^^^#OOOOO#^^##########################^^#OOOOOO#^^^^^#..........
.........##^^^#####^##############################^######^^^^^#...........
...........#########..............................############............
..........................................................................
..........................................................................
"

sleep 3
end

def mew
  puts"
  ..........................................................................
..........................................................................
.............@777777777777777.............................................
...........@^..............6..............................................
..........7..............3Q...............................................
.........73/@@@@@@@@@@@@).................................................
.........@6..........................OB@@@S/..............................
.........(B................(@@#(@@Q6........@G@@@@@@G.....................
........./@................@........................@.....................
.........S@................@........................(.....................
.........@/(...............@......................G@......................
..........@.@...............@...@#6...........@#\..G......................
...........@.3G............(/..@./**\......./**\.@..B.....................
............/K./@/.........@...@.**.*\...../**.*.@..K.....................
..............(@@./@#......@...@_****.......****_@..@.....................
.................^~@@(^^^(GR@......................#......................
......................^/.@@G~@....................@.......................
..............................^B@7@........../.(@^........................
..................................#3R......@@@7..^@~......................
..................................@..6@@@@K.G..^GR..(#....................
...............................,##..........@.....^#3.~S..................
............................Q##...............6......^Q~.@................
........................@67/...../..............K/.....^@.@...............
.........................@...6@7#...........R6/...^@.....@.@..............
..........................@@^..B............/~..G..Q......K.Q.............
..............................@..............S...C~.......O.G.............
.............................@................@.........../.(.............
............................#..................)........../.(.............
............................K....(..........~/.@..........#.R.............
............................(.....3..........#.3..........@.#.............
............................/.....~~.........K.).........#.#..............
............................@......6........@..#........@.@...............
............................(/.....~/......R...).....BK..@................
.............................@.....G......@...)~~~~~~..67.................
..............................@...@.S@@#R...~(Rsene~~@O^..................
............................RSR..(......#...@.............................
....................../#@G~^......@.....S....3B...........................
.................,~@6^........../@.......B6....^@S........................
..............~@^........../@G^^...........^~@....^^/@B...................
............Q73.........@#^...................^@6......^~@7...............
...........@@........7@^.........................(K........7@.............
..........@.@.....6O^..............................^#(...R/..@3/..........
..........@R.../@^....................................@....R/.3#..........
...........@R@(........................................^@,...@.@..........
..........................................................^@/@G...........
..........................................................................
"
end
snorlax
get_or_create_user
