require 'rails_helper'

RSpec.describe ImageUploader do
  let(:image) {create(:image, point_x: 50, point_y: 50)}
  let(:uploader) {ImageUploader.new(image, :picture)}

  before do
    ImageUploader.enable_processing = true
    File.open(File.join(Rails.root, '/spec/support/example.jpeg')) {|f| uploader.store!(f)}
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'store dir' do
    it { expect(uploader.store_dir).to end_with("uploads/image/picture/#{image.id}") }
  end

  context 'large version' do
    it 'fits original image to 800x600' do
      expect(uploader.large).to be_no_larger_than(800,600)
    end
  end

  context '1:1 version' do
    it 'scales 1:1 cropped area to 50x50' do
      expect(uploader.cropped50x50).to have_dimensions(50,50)
    end

    it 'scales 1:1 cropped area to 500x500' do
      expect(uploader.cropped500x500).to have_dimensions(500,500)
    end
  end

  context '1:4 version' do
    it 'scales 1:4 cropped area to 250x1000' do
      expect(uploader.cropped250x1000).to have_dimensions(250,1000)
    end
  end

  context '4:1 version' do
    it 'scales 4:1 cropped area to 1000x250' do
      expect(uploader.cropped1000x250).to have_dimensions(1000,250)
    end
  end
end
