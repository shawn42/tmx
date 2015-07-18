require 'spec_helper'

describe Tmx, "JSON Format" do

  let(:fixture_file) { File.join File.dirname(__FILE__), "..", "fixtures", "map.json" }

  let(:map) do
    described_class.load(fixture_file)
  end

  let(:subject) { map }

  its(:version) { should eq 1 }

  its(:height) { should eq 12 }
  its(:width) { should eq 16 }

  its(:tileheight) { should eq 32 }
  its(:tilewidth) { should eq 32 }

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

      its(:name) { should eq "Layer" }
      its(:opacity) { should eq 1 }
      its(:type) { should eq "tilelayer" }
      its(:visible) { should be true }
      its(:height) { should eq 12 }
      its(:width) { should eq 16 }
      its(:x) { should eq 0 }
      its(:y) { should eq 0 }

      its(:data) { should eq [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 141, 142, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 141, 142, 20, 0, 0, 0, 141, 142, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 29, 30, 0, 0, 0, 0, 0, 25, 26, 27, 0, 0, 0, 0, 0, 46, 47, 48, 0, 0, 0, 0, 0, 43, 44, 45, 0, 0, 0, 0, 0, 0, 65, 0, 0, 8, 8, 8, 23, 0, 80, 0, 137, 138, 0, 0, 0, 0, 83, 0, 0, 0, 0, 50, 0, 0, 80, 0, 191, 192, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 19, 37, 38, 37, 37, 37, 38, 37, 37, 37, 37, 37, 19, 37, 37, 37, 37, 37, 37, 37, 37] }
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
      its(:margin) { should eq 2 }
      its(:name) { should eq "tiles" }
      its(:spacing) { should eq 2 }
      its(:tileheight) { should eq 32 }
      its(:tilewidth) { should eq 32 }
      its(:properties) { should eq({ "alpha" => "1" }) }
    end
  end

  describe '#object_groups' do
    it "has the correct number of object groups" do
      expect(subject.object_groups).to have(1).item
    end

    context "when evaluating the first object group" do

      let(:subject) { map.object_groups.first }

      its(:name) { should eq "Objects" }
      its(:width) { should eq 16 }
      its(:height) { should eq 12 }
      its(:objects) { should have(6).items }
      its(:opacity) { should eq 1 }

      context "when evaluating a rectangluar object" do
        let(:subject) { map.object_groups.first.objects.first }

        its(:name) { should eq "ground" }
        its(:type) { should eq "floor" }
        its(:x) { should eq 0 }
        its(:y) { should eq 256 }
        its(:width) { should eq 512 }
        its(:height) { should eq 32 }
        its(:visible) { should be true }

        its(:properties) { should have(1).item }

        its(:shape) { should eq "polygon" }
        its(:points) { should eq [ "0,256", "512,256", "512,288", "0,288" ]}

        it "has the correct properties" do
          expect(subject.properties["type"]).to eq "sand"
        end
      end

      context "when evaluating a circular object" do

        let(:subject) { map.object_groups.first.objects[2] }

        its(:name) { should eq "mushroom" }
        its(:type) { should eq "mushroom" }
        its(:x) { should eq 256 }
        its(:y) { should eq 224 }
        its(:width) { should eq 32 }
        its(:height) { should eq 32 }
        its(:visible) { should be true }

        its(:properties) { should have(1).item }

        its(:shape) { should eq "ellipse" }

        it "has the correct properties" do
          expect(subject.properties["player.life.bonus"]).to eq "1"
        end

      end

      context "when evaluating a polygon (triangle)" do

        let(:subject) { map.object_groups.first.objects[3] }

        its(:name) { should eq "danger" }
        its(:type) { should eq "sign" }
        its(:x) { should eq 448 }
        its(:y) { should eq 192 }
        its(:shape) { should eq "polygon" }
        its(:points) { should eq [ "0,0", "32,64", "-32,64", "0,0"] }
        its(:visible) { should be true }

        its(:properties) { should have(0).items }

      end

      context "when evaluating a polyline (line segments)" do

        let(:subject) { map.object_groups.first.objects[4] }

        its(:name) { should eq "dirt" }
        its(:type) { should eq "underground" }
        its(:x) { should eq 32 }
        its(:y) { should eq 320 }
        its(:visible) { should be true }

        its(:properties) { should have(3).items }

        its(:shape) { should eq "polyline" }
        its(:points) { should eq ["0,0", "448,0", "448,64", "0,64", "0,0"]}

      end
    end

  end

  describe '#image_layers' do
    it "has the correct number of image layers" do
      expect(subject.image_layers).to have(1).item
    end

    context "when evaluating the first image layer" do
      let(:subject) { map.image_layers.first }

      its(:name) { should eq "Image Layer" }
      its(:width) { should eq 16 }
      its(:height) { should eq 12 }
    end
  end

end