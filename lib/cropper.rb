module Cropper
  def advanced_cropper(img, dimensions, point)
    ##TODO: got rid of if statements
    width = dimensions[:width]
    height = dimensions[:height]

    x = point[:x].to_i
    y = point[:y].to_i

    aspect_ratio = width.to_f / height

    if aspect_ratio >= 1
      multiplier = aspect_ratio == 1 ? 1 : aspect_ratio / 2

      case get_quadrant(img, x, y)
      when 1
        crop_width = if y - (img.width - x) / aspect_ratio >= 0
                       (img.width - x) * multiplier
                     else
                       y * (2 * aspect_ratio)
                     end
        crop_height = crop_width / aspect_ratio
      when 2
        crop_width = if y - x / aspect_ratio >= 0
                       x * multiplier
                     else
                       y * (2 * aspect_ratio)
                     end
        crop_height = crop_width / aspect_ratio
      when 3
        crop_width = if x / aspect_ratio + y <= img.height
                       x * multiplier
                     else
                       (img.height - y) * (2 * aspect_ratio)
                     end
        crop_height = crop_width / aspect_ratio
      when 4
        crop_width = if (img.width - x) / aspect_ratio + y <= img.height
                       (img.width - x) * multiplier
                     else
                       (img.height - y) * (2 * aspect_ratio)
                     end
        crop_height = crop_width / aspect_ratio
      end
    else
      inverted_aspect_ratio = height / width
      multiplier = inverted_aspect_ratio / 2

      case get_quadrant(img, x, y)
      when 1
        crop_height = if y / inverted_aspect_ratio + x <= img.width
                        y * multiplier
                      else
                        (img.width - x) * (2 * inverted_aspect_ratio)
                      end
        crop_width = crop_height / inverted_aspect_ratio
      when 2
        crop_height = if x - y / inverted_aspect_ratio >= 0
                        y * multiplier
                      else
                        x * (2 * inverted_aspect_ratio)
                      end
        crop_width = crop_height / inverted_aspect_ratio
      when 3
        crop_height = if x - (img.height - y) / inverted_aspect_ratio >= 0
                        (img.height - y) * multiplier
                      else
                        x * (2 * inverted_aspect_ratio)
                      end
        crop_width = crop_height / inverted_aspect_ratio
      when 4
        crop_height = if (img.height - y) / inverted_aspect_ratio + x <= img.width
                        (img.height - y) * multiplier
                      else
                        (img.width - x) * (2 * inverted_aspect_ratio)
                      end
        crop_width = crop_height / inverted_aspect_ratio
      end
    end

    img.crop "#{crop_width}x#{crop_height}+#{x - crop_width / 2}+#{y - crop_height / 2}"
    img
  end

  private


  def get_quadrant(img, x, y)
    return 1 if x >= img.width / 2 && y <= img.height / 2
    return 2 if x <= img.width / 2 && y <= img.height / 2
    return 3 if x <= img.width / 2 && y >= img.height / 2
    4
  end
end
