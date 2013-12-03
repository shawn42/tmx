require 'spec_helper'

describe Tmx, "Map with Source Tileset" do

  let(:fixture_file) { File.join File.dirname(__FILE__), "..", "fixtures", "map-source-tileset.tmx" }

  let(:map) do
    described_class.load(fixture_file)
  end

  let(:subject) { map }

  its(:width) { should eq 10 }
  its(:height) { should eq 20 }
  its(:tilewidth) { should eq 32 }
  its(:tileheight) { should eq 32 }

  describe '#layers' do
    it "has the correct number of layers" do
      expect(subject.layers).to have(1).item
    end
  end

  describe '#tilesets' do
    it "has the correct number of tilesets" do
      expect(subject.tilesets).to have(1).item
    end

    context "when evaluating the first tileset" do
      let(:subject) { map.tilesets.first }

      its(:firstgid) { should eq 1 }
      its(:image) { should eq "tiles.png" }
      its(:imageheight) { should eq 400 }
      its(:imagewidth) { should eq 640 }
      its(:margin) { should eq 0 }
      its(:spacing) { should eq 2 }
      its(:tileheight) { should eq 32 }
      its(:tilewidth) { should eq 32 }
      its(:properties) { should eq({}) }
    end
  end


end