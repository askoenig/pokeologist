# # require 'tty-prompt'
# # require 'pry'
# #
# # require_relative 'pokemon_api.rb'
# def test
#   puts "Are you a new user?"
#   input = gets.chomp
#   if input == 'y' || input == 'yes'
#     puts "create_user"
#   else input == 'n' || input == 'no'
#     puts "get_user"
#   end
# end
#
# def start_search
#   puts "How would you like to search?"
#   prompt = TTY::Prompt.new
#   input = prompt.select("Topic?", %w(Name Stats Types))
#   if input == 'Name'
#
#   elsif input == 'Stats'
#
#   else input == 'Types'
#
#   end
# end
#
#
# def choose_pokemon_name
#   puts "Please enter a pokemon name."
#   input = gets.chomp.downcase
#   binding.pry
# end
#
#
# # def get_user
# #   prompt = TTY::Prompt.new
# #   prompt.ask('Are you a new user?', default: ENV['USER'])
# #   prompt.yes?('Confirm')
# #   if input == 'y' || input == 'yes'
# #     puts "create_user"
# #   else input == 'n' || input == 'no'
# #     puts "get_user"
# #   end
# #
# # end
# start_search
# # choose_pokemon_name
