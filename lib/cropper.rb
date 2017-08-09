module Cropper
  def crop_dimensions(image_dimensions, dimensions, point)
    width  = dimensions[:width]
    height = dimensions[:height]

    img_width  = image_dimensions[:width]
    img_height = image_dimensions[:height]

    x = point[:x].to_i
    y = point[:y].to_i

    aspect_ratio = width.to_f / height

    if aspect_ratio >= 1
      multiplier = aspect_ratio == 1 ? 1 : aspect_ratio / 2

      case get_quadrant(image_dimensions, x, y)
      when 1
        crop_width = if y - (img_width - x) / aspect_ratio >= 0
                       (img_width - x) * multiplier
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
        crop_width = if x / aspect_ratio + y <= img_height
                       x * multiplier
                     else
                       (img_height - y) * (2 * aspect_ratio)
                     end
        crop_height = crop_width / aspect_ratio
      when 4
        crop_width = if (img_width - x) / aspect_ratio + y <= img_height
                       (img_width - x) * multiplier
                     else
                       (img_height - y) * (2 * aspect_ratio)
                     end
        crop_height = crop_width / aspect_ratio
      end
    else
      inverted_aspect_ratio = height / width
      multiplier = inverted_aspect_ratio / 2

      case get_quadrant(image_dimensions, x, y)
      when 1
        crop_height = if y / inverted_aspect_ratio + x <= img_width
                        y * multiplier
                      else
                        (img_width - x) * (2 * inverted_aspect_ratio)
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
        crop_height = if x - (img_height - y) / inverted_aspect_ratio >= 0
                        (img_height - y) * multiplier
                      else
                        x * (2 * inverted_aspect_ratio)
                      end
        crop_width = crop_height / inverted_aspect_ratio
      when 4
        crop_height = if (img_height - y) / inverted_aspect_ratio + x <= img_width
                        (img_height - y) * multiplier
                      else
                        (img_width - x) * (2 * inverted_aspect_ratio)
                      end
        crop_width = crop_height / inverted_aspect_ratio
      end
    end

    { crop_width: crop_width, crop_height: crop_height }
  end

  private

  def get_quadrant(image_dimensions, x, y)
    img_width  = image_dimensions[:width]
    img_height = image_dimensions[:height]

    return 1 if x >= img_width / 2 && y <= img_height / 2
    return 2 if x <= img_width / 2 && y <= img_height / 2
    return 3 if x <= img_width / 2 && y >= img_height / 2
    4
  end
end
