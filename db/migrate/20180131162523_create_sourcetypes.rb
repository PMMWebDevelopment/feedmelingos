class CreateSourcetypes < ActiveRecord::Migration[5.1]
  def change
    create_table :sourcetypes do |t|
      t.string :sourcetype

      t.timestamps
    end
  end
end
