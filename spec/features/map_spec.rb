require 'spec_helper'

describe Tmx::Map do

  let(:fixture_file) { File.join File.dirname(__FILE__), "..", "fixtures", "map_gzip.tmx" }

  let(:map) { Tmx.load fixture_file }

  describe "#objects" do

    it "contains all the objects in all object groups" do
      expect(map.objects).to have(5).objects
    end

    describe "when searching by type" do
      it "finds all the objects" do
        expect(map.objects.find(type: "floor")).to have(2).objects
        expect(map.objects.find(type: "mushroom")).to have(1).objects
      end
    end

    describe "when searching by name" do
      it "finds all the objects" do
        expect(map.objects.find(name: "ground")).to have(1).objects
        expect(map.objects.find(name: "platform")).to have(1).objects
      end
    end
  end

end