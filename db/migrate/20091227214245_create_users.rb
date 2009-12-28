class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :openid_identifier
      t.string :persistence_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      
      t.timestamps
    end
    
    add_index :users, :openid_identifier
  end

  def self.down
    remove_index :users, :openid_identifier
    drop_table :users
  end
end
