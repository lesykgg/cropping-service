class ImagesController < ApplicationController
  helper_method :image

  def show
    render :crop unless image.cropped?
  end

  def new
    @image = Image.new

    render :form
  end

  def create
    @image = Image.new(image_params)

    if image.save
      flash[:success] = t('flash.upload-success')
      redirect_to image
    else
      flash[:danger] = t('flash.image-missing')
      redirect_to root_path
    end
  end

  def update
    image.update_attributes(image_params)
    redirect_to image
  end

  private

  def image
    @image ||= Image.find(params[:id])
  end

  def image_params
    params.fetch(:image, {}).permit(:picture, :point_x, :point_y, :cropped)
  end
end
