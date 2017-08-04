class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{model.id}.#{file.extension}"
  end

  version :large do
    resize_to_limit(800, 600)
  end

  version :cropped50_50 do
    process :cropper1x1
    resize_to_fit(50, 50)
  end

  version :cropped500_500 do
    process :cropper1x1
    resize_to_fit(500, 500)
  end

  version :cropped1000_250 do
    process :cropper4x1
    resize_to_fit(1000, 250)
  end

  version :cropped250_1000 do
    process :cropper1x4
    resize_to_fit(250, 1000)
  end

  def cropper1x1
    if model.point_x.present?
      x = model.point_x.to_i
      y = model.point_y.to_i

      manipulate! do |img|
        case get_quadrant(img)
          when 1
            crop_width = crop_height = img.width - x < y ? (img.width - x) * 2 : y * 2
          when 2
            crop_width = crop_height = x < y ? x * 2 : y * 2
          when 3
            crop_width = crop_height = x < img.height - y ? x * 2 : (img.height - y) * 2
          when 4
            crop_width = crop_height = img.width - x < img.height - y ? (img.width - x) * 2 : (img.height - y) * 2
        end

        img.crop "#{crop_width}x#{crop_height}+#{x-crop_width/2}+#{y-crop_height/2}"
        img
      end
    end
  end

  def cropper4x1
    if model.point_x.present?
      x = model.point_x.to_i
      y = model.point_y.to_i

      manipulate! do |img|
        case get_quadrant(img)
          when 1
            crop_width = (img.width - x) / 4 + y >= 0 ? (img.width - x) * 2 : y * 8
            crop_height = crop_width / 4
          when 2
            crop_width = y - x / 4 >= 0 ? x * 2 : y * 8
            crop_height = crop_width / 4
          when 3
            crop_width = x / 4 + y <= img.height ? x * 2 : (img.height - y) * 8
            crop_height = crop_width / 4
          when 4
            crop_width = (img.width - x) / 4 + y <= img.height ? (img.width - x) * 2 : (img.height - y) * 8
            crop_height = crop_width / 4
        end

        img.crop "#{crop_width}x#{crop_height}+#{x-crop_width/2}+#{y-crop_height/2}"
        img
      end
    end
  end

  def cropper1x4
    if model.point_x.present?
      x = model.point_x.to_i
      y = model.point_y.to_i

      manipulate! do |img|
        case get_quadrant(img)
          when 1
            crop_height = y / 4 + x <= img.width ? y * 2 : (img.width - x) * 8
            crop_width = crop_height / 4
          when 2
            crop_height = x - y / 4 >= 0 ? y * 2 : x * 8
            crop_width = crop_height / 4
          when 3
            crop_height = (img.heigth - y) / 4 + x >= 0 ? (img.height - y) * 2 : x * 8
            crop_width = crop_height / 4
          when 4
            crop_height = (img.height - y) / 4 + x <= img.width ? (img.height - y) * 2 : (img.width - x) * 8
            crop_width = crop_height / 4
        end

        img.crop "#{crop_width}x#{crop_height}+#{x-crop_width/2}+#{y-crop_height/2}"
        img
      end
    end
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  private

  def get_quadrant(img)
    x = model.point_x.to_i
    y = model.point_y.to_i

    return 1 if x >= img.width / 2 && y < img.height / 2
    return 2 if x < img.width / 2 && y < img.height / 2
    return 3 if x <= img.width / 2 && y > img.height / 2
    4
  end
end
