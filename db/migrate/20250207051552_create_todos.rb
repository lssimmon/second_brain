class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :description
      t.boolean :completed
      t.integer :user_id

      t.timestamps
    end
  end
end
