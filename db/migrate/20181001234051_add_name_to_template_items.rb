class AddNameToTemplateItems < ActiveRecord::Migration[5.0]
  def change
    add_column :template_items, :name, :string
    add_column :template_items, :description, :text
    add_column :template_items, :start_date, :datetime
    add_column :template_items, :total_classes, :integer
  end
end
