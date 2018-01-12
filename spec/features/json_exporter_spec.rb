require 'spec_helper'

describe Tmx, "JSON Export Format" do
  # The order of layers in TMX JSON format is undefined and doesn't
  # affect the semantics. For this test, we sort the layers by name
  # alphabetically in order to ensure they compare correctly.
  def sort_layers_by_name(map_data)
    map_data["layers"].sort_by! { |layer| layer["name"] }
    map_data
  end

  let(:fixture_file) { File.join File.dirname(__FILE__), "..", "fixtures", "map.json" }
  let(:reference_json_structures) { sort_layers_by_name(MultiJson.load File.read(fixture_file)) }

  let(:map) do
    described_class.load(fixture_file)
  end

  describe "exported re-parsed JSON data" do
    let(:reexported_json_data) { map.export_to_string(:format => :json) }
    let(:subject) { sort_layers_by_name(MultiJson.load(reexported_json_data)) }

    it "matches the reference JSON data without losing any properties or data" do
      expect(subject).to eq reference_json_structures
    end
  end

end
