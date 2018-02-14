class AddColumnsToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :preloadsourcename, :string
    add_column :subscriptions, :preloadsourceurl, :string
  end
end
