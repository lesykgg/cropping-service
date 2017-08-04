class ImagesController < ApplicationController
  helper_method :image

  def new
    @image = Image.new
    render :form
  end

  def create
    @image = Image.new(image_params)
    if image.save
      redirect_to image_path(image)
    end
  end

  def update
    if image.update_attributes(image_params)
      if params[:image][:picture].present?
        render :crop
      else
        redirect_to image, notice: "Successfully updated image."
      end
    else
      render :new
    end
  end

  def show
    render :crop unless image.cropped?
  end

  private

  def image
    @image ||= Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:picture, :point_x, :point_y, :cropped)
  end
end
