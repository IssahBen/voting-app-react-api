class AddEmailToVoters < ActiveRecord::Migration[7.1]
  def change
    add_column :voters, :email, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
