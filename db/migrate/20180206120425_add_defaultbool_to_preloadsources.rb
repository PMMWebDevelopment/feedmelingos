class AddDefaultboolToPreloadsources < ActiveRecord::Migration[5.1]
  def change
    add_column :preloadsources, :defaultbool, :boolean
  end
end
