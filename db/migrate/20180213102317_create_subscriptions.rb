class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :preloadsource_id
      t.integer :language_id
      t.datetime :created_at

      t.timestamps
    end
  end
end
