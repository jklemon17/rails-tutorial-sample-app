class RenameActivationDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :acitvation_digest, :string
    add_column :users, :activation_digest, :string
  end
end
