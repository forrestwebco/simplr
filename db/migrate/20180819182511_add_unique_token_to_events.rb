class AddUniqueTokenToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :unique_token, :string
  end
end
