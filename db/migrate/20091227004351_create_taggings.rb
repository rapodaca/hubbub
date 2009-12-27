class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :article_id
      t.integer :tag_id
      
      t.timestamps
    end
    
    add_index :taggings, :article_id
    add_index :taggings, :tag_id
  end

  def self.down
    remove_index :taggings, :article_id
    remove_index :taggings, :tag_id
    
    drop_table :taggings
  end
end
