require 'rails_helper'

RSpec.describe 'Image crop' do
  let!(:image) { create(:image) }
  let(:uploader) { ImageUploader.new(image, :picture) }

  before { visit image_path(image) }

  context 'valid input' do
    it 'crops image' do
      fill_in 'image[point_x]', with: '150'
      fill_in 'image[point_y]', with: '150'
      click_button 'Crop'

      expect(page).to have_content('Download cropped images')
    end
  end

  context 'invalid input' do
    it 'not crops image' do
      click_button 'Crop'

      expect(page).to have_current_path("/images/#{image.id}")
    end
  end

  context 'correct dimensions' do
    before do
      ImageUploader.enable_processing = true
      File.open(File.join(Rails.root, '/spec/support/example.jpeg')) { |f| uploader.store!(f) }
    end

    after do
      ImageUploader.enable_processing = false
      uploader.remove!
    end

    it 'crops image with correct dimensions' do
      fill_in 'image[point_x]', with: '150'
      fill_in 'image[point_y]', with: '150'
      click_button 'Crop'

      expect(uploader.cropped50x50).to have_dimensions(50,50)
      expect(uploader.cropped500x500).to have_dimensions(500,500)
      expect(uploader.cropped1000x250).to have_dimensions(1000,250)
      expect(uploader.cropped250x1000).to have_dimensions(250,1000)
    end
  end
end
