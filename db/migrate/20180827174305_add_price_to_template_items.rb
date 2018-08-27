class AddPriceToTemplateItems < ActiveRecord::Migration[5.0]
  def change
    add_column :template_items, :price, :float
  end
end
