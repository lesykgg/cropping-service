FactoryGirl.define do
  factory :image do
    picture Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/example.jpeg')))
  end
end
