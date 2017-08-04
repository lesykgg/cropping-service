class AddFieldsToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :aspect_ratio, :float
    add_column :images, :cropped, :boolean, default: false
  end
end
