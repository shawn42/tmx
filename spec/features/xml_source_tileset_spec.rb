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

      it "has the correct number of tiles" do
        expect(subject.tiles).to have(2).items
        expect(subject.tiles[0]["properties"]).to eq ({ "animation-delay0" => "18", "animation-delay1" => "15", "animation-delay2" => "14", "animation-delay3" => "15", "animation-delay4" => "14", "animation-frame0" => "0", "animation-frame1" => "1", "animation-frame2" => "2", "animation-frame3" => "3", "animation-frame4" => "4" })
      end
    end
  end


end
