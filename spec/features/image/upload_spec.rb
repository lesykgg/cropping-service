require 'rails_helper'

RSpec.describe 'Image upload' do
  before { visit '/' }

  context 'valid input' do
    it 'creates new image' do
      attach_file('image[picture]', File.join(Rails.root, '/spec/support/example.jpg'))

      expect{ click_button 'Upload image' }.to change{ Image.count }.by(1)
    end
  end
  
  context 'invalid input' do
    it 'shouldnt create image' do
      click_button 'Upload image'

      expect(page).to have_current_path('/')
      expect(page).to have_content('Please, select image')
    end
  end
end
