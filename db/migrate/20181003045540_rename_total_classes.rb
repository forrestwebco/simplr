class RenameTotalClasses < ActiveRecord::Migration[5.0]
  def change
    rename_column :template_items, :total_classes, :total_students
  end
end
