require 'spec_helper'

describe Tmx, "JSON Format" do

  let(:map) do
    file_path = File.join File.dirname(__FILE__), "..", "fixtures", "map.json"
    described_class.load(file_path)
  end

  let(:subject) { map }

  its(:version) { should eq 1 }

  its(:height) { should eq 12 }
  its(:width) { should eq 16 }

  its(:tileheight) { should eq 50 }
  its(:tilewidth) { should eq 50 }

  its(:orientation) { should eq "orthogonal" }

  describe '#properties' do
    it "has the correct number of properties" do
      expect(subject.properties).to have(1).item
    end

    it "property values are correct" do
      expect(subject.properties["hero.position"]).to eq "400,525,1"
    end
  end

  describe '#layers' do
    it "has the correct number of layers" do
      expect(subject.layers).to have(1).item
    end

    context "when evaluating the first layer" do

      let(:subject) { map.layers.first }

      its(:name) { should eq "Tile Layer 1" }
      its(:opacity) { should eq 1 }
      its(:type) { should eq "tilelayer" }
      its(:visible) { should be_true }
      its(:height) { should eq 12 }
      its(:width) { should eq 16 }
      its(:x) { should eq 0 }
      its(:y) { should eq 0 }

      its(:data) { should eq [ 3, 3, 3, 3, 3, 3, 2, 5, 5, 7, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 4, 4, 7, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 4, 4, 7, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 4, 4, 7, 18, 9, 9, 17, 3, 3, 3, 3, 3, 3, 3, 3, 2, 4, 4, 15, 14, 4, 6, 7, 3, 3, 3, 3, 3, 3, 3, 3, 2, 4, 4, 4, 4, 4, 6, 7, 3, 3, 3, 3, 3, 18, 9, 17, 2, 4, 4, 10, 13, 4, 10, 11, 3, 3, 3, 3, 18, 14, 6, 7, 2, 4, 4, 7, 16, 8, 11, 3, 3, 3, 3, 3, 2, 4, 4, 15, 14, 4, 4, 7, 3, 3, 3, 3, 3, 3, 3, 3, 2, 4, 4, 4, 4, 4, 4, 7, 3, 3, 3, 3, 3, 3, 3, 3, 16, 8, 8, 8, 13, 4, 4, 7, 3, 3, 3, 3, 3, 3, 3, 3, 12, 12, 12, 12, 16, 8, 8, 11, 3, 3, 3, 3, 3, 3] }
    end

  end
end