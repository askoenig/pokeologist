class AddColumnPokedexNumberToPokemons < ActiveRecord::Migration[5.0]

  def change
    add_column :pokemons, :pokedex_number, :integer
  end

end
