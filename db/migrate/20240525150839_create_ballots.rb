class CreateBallots < ActiveRecord::Migration[7.1]
  def change
    create_table :ballots do |t|
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
