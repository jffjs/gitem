require 'spec_helper'

describe Gitem::Profile do
  
  def stub_read_yaml
    Gitem::Profile.stub!(:read_yaml).and_return(
      YAML::load(fixture('fixture.gitem.yml')))
  end

  describe "#open" do
    before do
      stub_read_yaml
    end

    it "should open the profile yaml" do
      profile = Gitem::Profile.open
      profile.repos.should be_an Array
      profile.ignored.should be_an Array
    end
  end

  describe ".save" do
    before do
      stub_read_yaml
    end

    it "should write the profile data to yaml file" do
      profile = Gitem::Profile.open
      Gitem::Profile.should_receive :write_yaml
      profile.save
    end
  end

  describe ".has_repo?" do

    it "should return true if the specified repo exists in profile" do
      stub_read_yaml
      File.stub!(:exists?).and_return(true)
      profile = Gitem::Profile.open
      repo = profile.repos.first

      profile.has_repo?(repo).should == true
    end
  end
end
