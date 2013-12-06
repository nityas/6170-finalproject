class AddPhoneToUsers < ActiveRecord::Migration
  def change
  	    add_column :users, :phoneNumber, :bigint
  	    add_column :users, :provider, :string
  end
end
