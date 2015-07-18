require 'spec_helper'

describe Tmx, "Isometric Map" do

  let(:fixture_file) { File.join File.dirname(__FILE__), "..", "fixtures", "map-isometric.tmx" }

  let(:map) do
    described_class.load(fixture_file)
  end

  let(:subject) { map }

  its(:width) { should eq 10 }
  its(:height) { should eq 20 }
  its(:tilewidth) { should eq 64 }
  its(:tileheight) { should eq 32 }

  describe '#layers' do
    it "has the correct number of layers" do
      expect(subject.layers).to have(1).item
    end

    context "when evaluating the first layer" do

      let(:subject) { map.layers.first }

      its(:name) { should eq "Tile Layer 1" }
      its(:opacity) { should eq 1 }
      its(:type) { should eq "tilelayer" }
      its(:visible) { should be true }
      its(:height) { should eq 20 }
      its(:width) { should eq 10 }
      its(:x) { should eq 0 }
      its(:y) { should eq 0 }

      its(:data) { should eq [3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2] }
    end
  end

  describe '#tilesets' do
    it "has the correct number of tilesets" do
      expect(subject.tilesets).to have(1).item
    end

    context "when evaluating the first tileset" do
      let(:subject) { map.tilesets.first }

      its(:firstgid) { should eq 1 }
      its(:image) { should eq "iso.png" }
      its(:imageheight) { should eq 96 }
      its(:imagewidth) { should eq 64 }
      its(:margin) { should eq 0 }
      its(:name) { should eq "Isometric" }
      its(:spacing) { should eq 0 }
      its(:tileheight) { should eq 32 }
      its(:tilewidth) { should eq 64 }
      its(:properties) { should eq({}) }
    end
  end


end