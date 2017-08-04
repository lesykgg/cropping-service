class Image < ApplicationRecord
  mount_uploader :picture, ImageUploader

  after_update :crop_image

  after_create :count_aspect_ratio

  attr_accessor :point_x, :point_y

  def crop_image
    if point_x.present?
      picture.recreate_versions!
      update_columns(cropped: true)
    end
  end

  def img
    @img ||= MiniMagick::Image.open(picture.path)
  end

  def img_large
    @img_large ||= MiniMagick::Image.open(picture.versions[:large].path)
  end

  def count_aspect_ratio
    update(aspect_ratio: img['width'].to_f / img_large['width'])
  end
end
