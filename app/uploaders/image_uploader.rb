class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ::Cropper

  storage :file
  # when adding new dimension - dont forget to add link in appropriate view
  # also deleting existing dimensions will cause some test failing - remove them
  DIMENSIONS = {
    '50x50'    => { width: 50,   height: 50 },
    '500x500'  => { width: 500,  height: 500 },
    '1000x250' => { width: 1000, height: 250 },
    '250x1000' => { width: 250,  height: 1000 }
  }.freeze

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{model.id}.#{file.extension}"
  end

  version :large do
    resize_to_limit(800, 600)
  end

  DIMENSIONS.each do |k, v|
    version "cropped#{k}" do
      process cropper: [v[:width], v[:height]]
    end
  end

  def cropper(width, height)
    return unless model.point_x.present?

    dimensions = { width: width, height: height }
    point      = { x: model.point_x, y: model.point_y }

    manipulate! do |img|
      image_dimensions      = { width: img.width, height: img.height }
      image_crop_dimensions = crop_dimensions(image_dimensions, dimensions, point)

      crop_width  = image_crop_dimensions[:crop_width]
      crop_height = image_crop_dimensions[:crop_height]

      img.crop "#{crop_width}x#{crop_height}+#{point[:x] - crop_width / 2}+#{point[:y] - crop_height / 2}"
      img
    end
    resize_to_fill(width, height)
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
