class AddStatusToBallots < ActiveRecord::Migration[7.1]
  def change
    add_column :ballots, :status, :string,default: "inactive" 
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
