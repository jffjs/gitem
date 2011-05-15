require 'spec_helper'

describe Gitem::Repository do
  
  describe '#remote_repos' do
  end

  describe '.full_name' do
    it "should return the full name of the repo" do
      owner = 'jffjs'
      name = 'gitem'
      repo = Gitem::Repository.new(owner, name, 'http://url.com', '/fake/path')
      repo.full_name.should == "#{owner}/#{name}"
    end
  end
end
