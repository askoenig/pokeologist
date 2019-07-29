class CreatePokemons < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemons do |t|
    t.string :name
    t.integer :hp
    t.integer :attack
    t.integer :defense
    t.integer :special_att
    t.integer :special_def
    t.integer :speed
    t.string :type_1
    t.string :type_2
    end
  end
end
