require 'rails_helper'

RSpec.describe 'Image crop' do
  let!(:image) { create(:image) }
  let(:uploader) { ImageUploader.new(image, :picture) }

  before { visit "/images/#{image.id}" }

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
    it 'crops image with correct dimensions' do
      ImageUploader.enable_processing = true
      File.open(File.join(Rails.root, '/spec/support/example.jpeg')) { |f| uploader.store!(f) }
      fill_in 'image[point_x]', with: '150'
      fill_in 'image[point_y]', with: '150'
      click_button 'Crop'

      expect(uploader.cropped50_50).to have_dimensions(50,50)
      expect(uploader.cropped500_500).to have_dimensions(500,500)
      expect(uploader.cropped1000_250).to have_dimensions(1000,250)
      expect(uploader.cropped250_1000).to have_dimensions(250,1000)
      ImageUploader.enable_processing = false
      uploader.remove!
    end
  end
end
