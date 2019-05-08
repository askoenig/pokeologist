class CreateTeams < ActiveRecord::Migration[5.0]

  def change
    create_table :teams do |t|
      t.integer :user_id
      t.integer :pokemon_id
      t.string :team_name
    end
  end

end
