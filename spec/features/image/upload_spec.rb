require 'rails_helper'

RSpec.describe 'Image upload' do
  before { visit root_path }

  context 'valid input' do
    it 'creates new image' do
      attach_file('image[picture]', File.join(Rails.root, '/spec/support/example.jpeg'))

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
