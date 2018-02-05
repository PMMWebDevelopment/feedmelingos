class CreatePreloadsources < ActiveRecord::Migration[5.1]
  def change
    create_table :preloadsources do |t|
      t.string :preloadsourcename
      t.string :preloadsourceurl
      t.integer :language_id
      t.integer :sourcetype_id

      t.timestamps
    end
  end
end
