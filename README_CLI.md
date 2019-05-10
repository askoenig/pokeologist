# Pokemon Research Data Command Line Interface

Hello Pokéologist! Welcome to Aaron & Andrew's Pokémon Research Center. Here is your one stop shop(?) for researching Generation 1 Pokémon.

Side Note: Data besides those included in this CLI can be added from the Pokémon API (https://pokeapi.co/) and Pokémon after Generation 2 can be added to this database.

#Install Instructions

Github: Fork and clone this repository. Navigate, in terminal, to the folder you cloned this repository in.

From Terminal:
1. Enter $ bundle install to install gems.
2. Enter $ rake db:migrate to create the tables in you database.
3. Enter $ rake db:seed to collect data from the Pokémon API and populate our tables.
4. Enter $ ruby bin/cli.rb to run program
5. (Optional) Open the file with your text editor of choice to make whatever edits you want.

#User Interaction
-As a user, I want to be able to make an account that will save to a database and be accessible at a later time.
-As a user, I want to be able to browse Pokémon data utilizing a variety of search options (e.g. "Find Strongest Overall Pokémon"
-As a user I want to be able to make a team and fill it with Pokémon to research.
-As a user I want to be able to add and remove Pokémon from my team.
