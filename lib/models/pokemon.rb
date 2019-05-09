class Pokemon < ActiveRecord::Base
  has_many :teams
  has_many :users, through: :teams

  def self.highest_attack
    all.max_by(&:attack)
  end

  def self.lowest_attack
    all.min_by(&:attack)
  end

  def self.highest_defense
    all.max_by(&:defense)
  end

  def self.lowest_defense
    all.min_by(&:defense)
  end

  def self.highest_hp
    all.max_by(&:hp)
  end

  def self.lowest_hp
    all.min_by(&:hp)
  end

  def self.highest_speed
    all.max_by(&:speed)
  end

  def self.lowest_speed
    all.min_by(&:speed)
  end

  def self.strongest_overall_pokemon
    all.select do |pokemon|
      pokemon.attack >= 100 && pokemon.defense >= 90 && pokemon.hp >= 90 && pokemon.speed >= 80
    end
  end

  def self.weakest_overall_pokemon
    all.select do |pokemon|
      pokemon.attack <= 50 && pokemon.defense <= 50 && pokemon.hp <= 50 && pokemon.speed <= 50
    end
  end

  def self.search_by_type(type)
    all.select {|pokemon| pokemon.type_1 == type || pokemon.type_2 == type}
  end

  def self.search_pokedex_number(user_pokedex_number)
    all.select {|pokemon| pokemon.pokedex_number == user_pokedex_number}
  end



end
