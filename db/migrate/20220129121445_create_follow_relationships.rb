# frozen_string_literal: true

class CreateFollowRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :follow_relationships do |t|
      t.integer :following_user_id
      t.integer :followed_user_id

      t.timestamps
    end
    add_index :follow_relationships, :following_user_id
    add_index :follow_relationships, :followed_user_id
    add_index :follow_relationships, %i[following_user_id followed_user_id], unique: true
  end
end
