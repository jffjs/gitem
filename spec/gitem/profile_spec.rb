require 'spec_helper'

describe Gitem::Profile do
  
  def stub_read_yaml(fixture_path)
    Gitem::Profile.stub!(:read_yaml).and_return(
      YAML::load(fixture(fixture_path)))
  end

  describe "#open" do

    it "should open the profile yaml" do
      stub_read_yaml 'fixture.gitem.yml'
      profile = Gitem::Profile.open
      profile.repos.should be_an Array
      profile.ignored.should be_an Array
    end
    
    it "should initialize empty arrays if profile is empty" do
      stub_read_yaml 'empty.gitem.yml'
      profile = Gitem::Profile.open
      profile.repos.should be_empty
      profile.ignored.should be_empty
    end
  end

  describe ".save" do
    before do
      stub_read_yaml 'fixture.gitem.yml'
    end

    it "should write the profile data to yaml file" do
      profile = Gitem::Profile.open
      Gitem::Profile.should_receive :write_yaml
      profile.save
    end
  end

  describe ".add_repo" do
    
    it "should add the repo to the profiles list of repos" do
      stub_read_yaml 'empty.gitem.yml'
      profile = Gitem::Profile.open
      repo = Gitem::Repository.new('jffjs', 'gitem')
      profile.add_repo(repo)
      profile.repos.should include repo
    end
  end

  describe ".remove_repo" do
    
    it "should remove the repo from the profiles list of repos" do
      stub_read_yaml 'fixture.gitem.yml'
      profile = Gitem::Profile.open
      repo = Gitem::Repository.new('jffjs', 'gitem')
      profile.remove_repo(repo)
      profile.repos.should_not include repo
    end
  end

  describe ".has_repo?" do

    it "should return true if the specified repo exists in profile" do
      stub_read_yaml 'fixture.gitem.yml'
      File.stub!(:exists?).and_return(true)
      profile = Gitem::Profile.open
      repo = profile.repos.first

      profile.has_repo?(repo).should == true
    end
  end

  describe ".ignored?" do
    
    before do
      stub_read_yaml 'fixture.gitem.yml'
    end

    it "should return true if the specified repo is in the ignored list" do
      profile = Gitem::Profile.open
      profile.ignored?('rails/rails').should be_true
    end

    it "should return true for all repos for a user when 'user/*' is in ignored list" do
      profile = Gitem::Profile.open
      profile.ignored << 'jffjs/*'
      profile.ignored?('jffjs/gitem').should be_true
      profile.ignored?('jffjs/moria').should be_true
    end
  end
end
