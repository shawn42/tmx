require File.join(File.dirname(__FILE__), 'spec_helper')
describe 'nokogiri additions' do
  before(:all) { $doc = File.join($data_dir, 'test.tmx') }
  after(:all)  { $doc = nil }
end
