class AddUrlToTemplateItems < ActiveRecord::Migration[5.0]
  def change
    add_column :template_items, :url, :string
  end
end
