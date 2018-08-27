class AddItemTypeToTemplateItems < ActiveRecord::Migration[5.0]
  def change
    add_column :template_items, :item_type, :string
  end
end
