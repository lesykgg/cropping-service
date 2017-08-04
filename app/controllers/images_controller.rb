class ImagesController < ApplicationController
  helper_method :image

  def new
    @image = Image.new
    render :form
  end

  def create
    @image = Image.new(image_params)
    if image.save
      flash[:success] = 'Image was successfully uploaded'
      redirect_to image
    else
      flash[:danger] = 'Please, select image'
      redirect_to root_path
    end
  end

  def update
    if image.update_attributes(image_params)
      if params[:image][:picture].present?
        render :show
      else
        redirect_to image
      end
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
    params.fetch(:image, {}).permit(:picture, :point_x, :point_y, :cropped)
  end
end
