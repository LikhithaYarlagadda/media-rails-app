class CreateReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :reactions do |t|
      t.string :reaction_type, null: false # Like, Dislike, etc.
      t.references :reactable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
