class Image < ApplicationRecord
  mount_uploader :picture, ImageUploader

  after_create :count_aspect_ratio

  after_update :crop_image

  attr_accessor :point_x, :point_y

  validates_presence_of :picture

  def crop_image
    return unless point_x.present? && point_y.present?

    picture.recreate_versions!
    update_columns(cropped: true)
  end

  def img
    MiniMagick::Image.open(picture.path)
  end

  def img_large
    MiniMagick::Image.open(picture.versions[:large].path)
  end

  def count_aspect_ratio
    update(aspect_ratio: img['width'].to_f / img_large['width'])
  end
end
