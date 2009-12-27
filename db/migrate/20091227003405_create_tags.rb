class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :slug
      
      t.timestamps
    end
    
    add_index :tags, :slug
  end

  def self.down
    remove_index :tags, :slug
    
    drop_table :tags
  end
end
