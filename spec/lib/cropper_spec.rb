require 'rails_helper'

RSpec.describe Cropper do
  let(:image) { MiniMagick::Image.open(File.join(Rails.root, '/spec/support/example.jpeg'))}
  let(:dimensions4x1) { { width: 1000, height: 250 } }
  let(:dimensions1x4) { { width: 250, height: 1000 } }
  let(:klass) { Class.new { include Cropper } }

  context '4:1' do
    context 'first quadrant' do
      it 'returns correctly cropped image, (width - x) / 4 - y >= 0' do
        point = { x: 182, y: 50 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(180)
        expect(output.height).to eq(45)
      end

      it 'returns correctly cropped image, (width - x) / 4 - y < 0' do
        point = { x: 182, y: 20 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(160)
        expect(output.height).to eq(40)
      end
    end

    context 'second quadrant' do
      it 'returns correctly cropped image, x / 4 - y >= 0' do
        point = { x: 60, y: 50 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(120)
        expect(output.height).to eq(30)
      end

      it 'returns correctly cropped image, x / 4 - y < 0' do
        point = { x: 60, y: 5 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(40)
        expect(output.height).to eq(10)
      end
    end

    context 'third quadrant' do
      it 'returns correctly cropped image, x / 4 + (height - y) <= height' do
        point = { x: 60, y: 110 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(120)
        expect(output.height).to eq(30)
      end

      it 'returns correctly cropped image, x / 4 + (height - y) > height' do
        point = { x: 60, y: 180 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(48)
        expect(output.height).to eq(12)
      end
    end

    context 'fourth quadrant' do
      it 'returns correctly cropped image, (width - x) / 4 + (height - y) <= height' do
        point = { x: 150, y: 110 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(244)
        expect(output.height).to eq(61)
      end

      it 'returns correctly cropped image, (width - x) / 4 + (height - y) > height' do
        point = { x: 150, y: 180 }
        output = klass.new.advanced_cropper(image, dimensions4x1, point)

        expect(output.width).to eq(48)
        expect(output.height).to eq(12)
      end
    end
  end

  context '1:4' do
    context 'first quadrant' do
      it 'returns correctly cropped image, y / 4 + x <= width' do
        point = { x: 200, y: 38 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(19)
        expect(output.height).to eq(76)
      end

      it 'returns correctly cropped image, y / 4 + x > width' do
        point = { x: 267, y: 42 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(10)
        expect(output.height).to eq(40)
      end
    end

    context 'second quadrant' do
      it 'returns correctly cropped image, x - y / 4 >= 0' do
        point = { x: 58, y: 32 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(16)
        expect(output.height).to eq(64)
      end

      it 'returns correctly cropped image, x - y / 4 < 0' do
        point = { x: 9, y: 51 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(18)
        expect(output.height).to eq(72)
      end
    end

    context 'third quadrant' do
      it 'returns correctly cropped image, x - (height - y) >= 0' do
        point = { x: 92, y: 137 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(24)
        expect(output.height).to eq(98)
      end

      it 'returns correctly cropped image, x - (height - y) < 0' do
        point = { x: 5, y: 124 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(10)
        expect(output.height).to eq(40)
      end
    end

    context 'fourth quadrant' do
      it 'returns correctly cropped image, (height - y) / 4 + x <= width' do
        point = { x: 177, y: 120 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(33)
        expect(output.height).to eq(132)
      end

      it 'returns correctly cropped image, (height - y) / 4 + x > width' do
        point = { x: 267, y: 136 }
        output = klass.new.advanced_cropper(image, dimensions1x4, point)

        expect(output.width).to eq(10)
        expect(output.height).to eq(40)
      end
    end
  end
end