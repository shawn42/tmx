require File.join(File.dirname(__FILE__), 'spec_helper')
describe 'Coder' do
  it 'can find the default coders' do
    Tmx::Coder.find_coder(:base64).should_not == nil
    Tmx::Coder.find_coder(:gzip).should_not   == nil
  end
  
  CODER_TEST_STRING = <<-EOS
    Lorem ipsum dolor sit amet, consecteteur adapiscing elit.
  EOS
  
  def coder_round_trip *encodings
    encoded = Tmx::Coder.encode CODER_TEST_STRING, *encodings
    decoded = Tmx::Coder.decode encoded, *encodings
    decoded.should == CODER_TEST_STRING
  end
  
  it 'can round trip base64' do
    coder_round_trip :base64
  end
  
  it 'can round trip gzip' do
    coder_round_trip :gzip
  end
  
  it 'can round trip multiple encodings' do
    coder_round_trip :gzip, :base64
  end
end
