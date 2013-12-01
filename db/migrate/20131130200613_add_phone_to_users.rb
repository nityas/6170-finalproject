class AddPhoneToUsers < ActiveRecord::Migration
  def change
  	    add_column :users, :phoneNumber, :integer
  	    add_column :users, :provider, :String
  end
end
