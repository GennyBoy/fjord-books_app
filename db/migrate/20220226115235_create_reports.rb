class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :title
      t.string :content
      t.integer :user_id, null: false

      t.timestamps
    end
    add_foreign_key :reports, :users
    add_index :reports, :user_id
  end
end
