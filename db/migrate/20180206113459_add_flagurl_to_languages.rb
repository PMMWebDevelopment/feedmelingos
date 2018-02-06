class AddFlagurlToLanguages < ActiveRecord::Migration[5.1]
  def change
    add_column :languages, :flagurl, :string
  end
end
