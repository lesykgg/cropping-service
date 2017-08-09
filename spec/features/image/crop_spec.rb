require 'rails_helper'

RSpec.describe 'Image crop' do
  let!(:image) { create(:image) }

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
    it 'refuses to crop image' do
      click_button 'Crop'

      expect(page).to have_current_path("/images/#{image.id}")
      expect(page).to have_no_content('Download cropped images')
    end
  end
end
